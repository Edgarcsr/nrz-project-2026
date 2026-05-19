library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity top_vga_nrz_i is
    Generic (
        DATA_WIDTH    : integer := 16;
        TICKS_PER_BIT : integer := 10
    );
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        data_in : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        -- LEDs (mantidos iguais ao projeto original)
        nrz_out : out STD_LOGIC;
        bit_idx : out integer range 0 to DATA_WIDTH - 1;
        -- VGA 1920x1080 @ 60Hz
        vga_hs  : out STD_LOGIC;
        vga_vs  : out STD_LOGIC;
        vga_r   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_g   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_b   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end top_vga_nrz_i;

architecture Behavioral of top_vga_nrz_i is

    -- Sinais internos do NRZ-I
    signal nrz_sig : STD_LOGIC;
    signal idx_sig : integer range 0 to DATA_WIDTH - 1;

    -- Clock gerado pelo MMCM (~148.5 MHz para 1920x1080@60Hz)
    signal clk_pixel    : STD_LOGIC;
    signal clk_feedback : STD_LOGIC;
    signal mmcm_locked  : STD_LOGIC;

    -- Contadores VGA
    -- 1920x1080 @ 60Hz:
    -- Horizontal: 1920 visivel + 88 front + 44 sync + 148 back = 2200 total
    -- Vertical:   1080 visivel + 4 front  + 5 sync  + 36 back  = 1125 total
    signal h_count : integer range 0 to 2199 := 0;
    signal v_count : integer range 0 to 1124 := 0;
    signal active  : STD_LOGIC;

begin

    -- ----------------------------------------------------------------
    -- MMCM para gerar 148.5 MHz a partir de 100 MHz
    -- VCO = 100 * 37.125 / 5 = 742.5 MHz
    -- CLKOUT0 = 742.5 / 5 = 148.5 MHz
    -- ----------------------------------------------------------------
    MMCM_inst : MMCME2_BASE
        generic map (
            BANDWIDTH          => "OPTIMIZED",
            CLKFBOUT_MULT_F    => 37.125,
            CLKFBOUT_PHASE     => 0.0,
            CLKIN1_PERIOD      => 10.0,
            CLKOUT0_DIVIDE_F   => 5.0,
            CLKOUT0_DUTY_CYCLE => 0.5,
            CLKOUT0_PHASE      => 0.0,
            DIVCLK_DIVIDE      => 5,
            REF_JITTER1        => 0.0,
            STARTUP_WAIT       => FALSE
        )
        port map (
            CLKIN1   => clk,
            CLKFBIN  => clk_feedback,
            CLKFBOUT => clk_feedback,
            CLKOUT0  => clk_pixel,
            LOCKED   => mmcm_locked,
            PWRDWN   => '0',
            RST      => '0'
        );

    -- ----------------------------------------------------------------
    -- Instancia o nrz_i original sem modificacao
    -- ----------------------------------------------------------------
    U_NRZ_I: entity work.nrz_i
        Generic map (
            DATA_WIDTH    => DATA_WIDTH,
            TICKS_PER_BIT => TICKS_PER_BIT
        )
        Port map (
            clk     => clk,
            reset   => reset,
            data_in => data_in,
            nrz_out => nrz_sig,
            bit_idx => idx_sig
        );

    -- Conecta sinais internos nas portas dos LEDs
    nrz_out <= nrz_sig;
    bit_idx <= idx_sig;

    -- ----------------------------------------------------------------
    -- Contadores VGA rodando no pixel clock de 148.5 MHz
    -- ----------------------------------------------------------------
    process(clk_pixel, reset)
    begin
        if reset = '1' then
            h_count <= 0;
            v_count <= 0;
        elsif rising_edge(clk_pixel) then
            if h_count = 2199 then
                h_count <= 0;
                if v_count = 1124 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;
            else
                h_count <= h_count + 1;
            end if;
        end if;
    end process;

    -- ----------------------------------------------------------------
    -- Sincronismo 1920x1080 @ 60Hz (polaridade POSITIVA)
    -- Hsync: pixels 2008 a 2051
    -- Vsync: linhas 1084 a 1088
    -- ----------------------------------------------------------------
    vga_hs <= '1' when (h_count >= 2008 and h_count < 2052) else '0';
    vga_vs <= '1' when (v_count >= 1084 and v_count < 1089) else '0';

    -- Area visivel
    active <= '1' when (h_count < 1920 and v_count < 1080) else '0';

    -- ----------------------------------------------------------------
    -- Cor: vermelho se nrz alto, azul se nrz baixo
    -- ----------------------------------------------------------------
    process(active, nrz_sig)
    begin
        if active = '1' then
            if nrz_sig = '1' then
                vga_r <= "1111";
                vga_g <= "0000";
                vga_b <= "0000";
            else
                vga_r <= "0000";
                vga_g <= "0000";
                vga_b <= "1111";
            end if;
        else
            vga_r <= "0000";
            vga_g <= "0000";
            vga_b <= "0000";
        end if;
    end process;

end Behavioral;
