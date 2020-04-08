library IEEE;
use IEEE.std_logic_1164.all;

entity DFF is
    port(
        d: in std_logic;
        clk: in std_logic;
        rst: in std_logic;
        q: out std_logic);
end DFF;

architecture rtl of DFF is
begin
    dff_proc: process(clk, rst)
    begin
--      if the reset signal is '0', the output has to go to '0'
        if(rst='0') then
            q <= '0';
--      if the reset is not '0' and a positive edge of the edge is found
--      then the output takes the value of the input
        elsif(rising_edge(clk)) then
            q <= d;
        end if;
    end process;
end rtl;