library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nrz_i is
    Generic (
        DATA_WIDTH    : integer := 16; -- data size to be read
        TICKS_PER_BIT : integer := 100000000  -- clk cycles per bit
    );
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        data_in : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0); -- payload
        nrz_out : out STD_LOGIC; -- our serial tx line
        bit_idx : out integer range 0 to DATA_WIDTH - 1 -- exposing for easy debugging in waveform
    );
end nrz_i;

architecture Behavioral of nrz_i is
    -- internal configuration
    signal bit_ptr : integer range 0 to DATA_WIDTH - 1 := DATA_WIDTH - 1; -- start from the msb
    signal tick_counter : integer range 0 to TICKS_PER_BIT - 1 := 0; 
    
    -- nrzi needs to remember the last line state to know if it should toggle
    signal current_lvl : std_logic := '0'; 
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- clean slate on reset
            bit_ptr <= DATA_WIDTH - 1;
            tick_counter <= 0;
            current_lvl <= '0';
            nrz_out <= '0';
        elsif rising_edge(clk) then
            
            -- nrzi logic: evaluate only at the start of a new bit cycle
            if tick_counter = 0 then
                if data_in(bit_ptr) = '1' then
                    -- 1 means toggle the line
                    current_lvl <= not current_lvl;
                    nrz_out <= not current_lvl; -- instantly push to output
                else
                    -- 0 means hold the previous state
                    nrz_out <= current_lvl;
                end if;
            else
                -- just hold the line steady for the rest of the bit duration
                nrz_out <= current_lvl;
            end if;

            -- handle the timing and pointer (same as nrz-l)
            if tick_counter < TICKS_PER_BIT - 1 then
                -- increment counter
                tick_counter <= tick_counter + 1;
            else
                -- reset the counter
                tick_counter <= 0;
                
                if bit_ptr = 0 then
                    -- loop if data finished being read
                    bit_ptr <= DATA_WIDTH - 1;
                else
                    -- move on to the next bit down
                    bit_ptr <= bit_ptr - 1;
                end if;
            end if;
        end if;
    end process;

    -- wire the internal pointer out to the testbench
    bit_idx <= bit_ptr;

end Behavioral;