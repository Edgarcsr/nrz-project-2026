library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nrz_i_tb is
end nrz_i_tb;

architecture sim of nrz_i_tb is
    -- system configuration
    constant CLK_PERIOD : time := 2 ns;
    constant BIT_PERIOD : time := 20 ns;
    constant TICKS_VAL  : integer := 10;
    constant DATA_W     : integer := 16;

    -- DUT (device under test), mockup
    signal clk_tb     : STD_LOGIC := '0';
    signal reset_tb   : STD_LOGIC := '0';
    -- using the exact same payload as nrz-l to compare waveforms easily
    signal data_in_tb : STD_LOGIC_VECTOR(DATA_W - 1 downto 0) := "1100101011110001"; 
    signal nrz_out_tb : STD_LOGIC;
    signal bit_idx_tb : integer range 0 to DATA_W - 1;

begin
    uut: entity work.nrz_i
        generic map (
            DATA_WIDTH    => DATA_W,
            TICKS_PER_BIT => TICKS_VAL
        )
        port map (
            clk     => clk_tb,
            reset   => reset_tb,
            data_in => data_in_tb,
            nrz_out => nrz_out_tb,
            bit_idx => bit_idx_tb
        );

    -- clock generator
    clk_process : process
    begin
        while true loop
            clk_tb <= '0'; wait for CLK_PERIOD/2;
            clk_tb <= '1'; wait for CLK_PERIOD/2;
        end loop;
    end process;

    stim_proc: process
    begin        
        -- initialize with the reset button for cleanup
        reset_tb <= '1';
        wait for 10 ns;
        reset_tb <= '0';

        -- wait for data to be fully read
        wait for DATA_W * BIT_PERIOD;

        wait;
    end process;
end sim;