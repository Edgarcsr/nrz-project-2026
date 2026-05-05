library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nrz_i_tb is
end nrz_i_tb;

architecture sim of nrz_i_tb is
    -- Timing constants
    constant CLK_PERIOD : time := 2 ns;
    constant BIT_PERIOD : time := 20 ns;
    constant TICKS_VAL  : integer := 10;

    signal clk_tb     : STD_LOGIC := '0';
    signal reset_tb   : STD_LOGIC := '0';
    signal data_in_tb : STD_LOGIC_VECTOR(15 downto 0) := "1101100011110001";
    signal nrz_out_tb : STD_LOGIC;

begin
    uut: entity work.nrz_i
        generic map (
            TICKS_PER_BIT => TICKS_VAL
        )
        port map (
            clk     => clk_tb,
            reset   => reset_tb,
            data_in => data_in_tb,
            nrz_out => nrz_out_tb
        );

    clk_process : process
    begin
        while true loop
            clk_tb <= '0'; wait for CLK_PERIOD/2;
            clk_tb <= '1'; wait for CLK_PERIOD/2;
        end loop;
    end process;

    stim_proc: process
    begin		
        reset_tb <= '1';
        wait for 10 ns;
        reset_tb <= '0';

        -- Observe the output waveform for one full 16-bit sequence
        wait for 16 * BIT_PERIOD;

        wait;
    end process;
end sim;