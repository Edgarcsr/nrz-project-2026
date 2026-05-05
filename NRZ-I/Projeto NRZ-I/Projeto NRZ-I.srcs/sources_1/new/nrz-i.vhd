library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nrz_i is
    Generic (
        TICKS_PER_BIT : integer := 10
    );
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR(15 downto 0);
        nrz_out  : out STD_LOGIC
    );
end nrz_i;

architecture Behavioral of nrz_i is
    signal bit_ptr : integer range 0 to 15 := 15;
    signal tick_counter : integer range 0 to TICKS_PER_BIT - 1 := 0;
    signal current_level : STD_LOGIC := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            bit_ptr <= 15;
            tick_counter <= 0;
            current_level <= '0';
        elsif rising_edge(clk) then
            -- Transition logic at the start of each bit period
            if tick_counter = 0 then
                if data_in(bit_ptr) = '1' then
                    current_level <= not current_level;
                end if;
            end if;

            -- Timing and bit sequence management
            if tick_counter < TICKS_PER_BIT - 1 then
                tick_counter <= tick_counter + 1;
            else
                tick_counter <= 0;
                if bit_ptr = 0 then
                    bit_ptr <= 15;
                else
                    bit_ptr <= bit_ptr - 1;
                end if;
            end if;
        end if;
    end process;

    nrz_out <= current_level;
end Behavioral;