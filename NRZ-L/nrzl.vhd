library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nrz_l_encoder is
    Generic (
        TICKS_PER_BIT : integer := 10
    );
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR(15 downto 0);
        nrz_out  : out STD_LOGIC
    );
end nrz_l_encoder;

architecture Behavioral of nrz_l_encoder is
    signal bit_ptr : integer range 0 to 15 := 15;
    signal tick_counter : integer range 0 to TICKS_PER_BIT - 1 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            bit_ptr <= 15;
            tick_counter <= 0;
            nrz_out <= '0';
        elsif rising_edge(clk) then
            nrz_out <= data_in(bit_ptr);

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
end Behavioral;