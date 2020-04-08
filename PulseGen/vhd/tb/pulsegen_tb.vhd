library IEEE;
use IEEE.std_logic_1164.all;

entity pulsegen_tb is
end pulsegen_tb;

architecture test of pulsegen_tb is

    constant T_CLK : time := 8 ns;
    
    signal mode_tb : std_logic;
    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '0';
    signal o_tb : std_logic;
    signal err_tb : std_logic;
    
    signal end_sim_tb : std_logic := '0';
    
    component pulsegen is
        port(
            m : in std_logic;
            clock : in std_logic;
            reset : in std_logic;
            o : out std_logic;
            err : out std_logic);
    end component;
    
    begin
    
        clk_tb <= not(clk_tb) or end_sim_tb after T_CLK/2;
        end_sim_tb <= '1' after T_CLK*250;
            
        dut:pulsegen
            port map(
                m => mode_tb,
                clock => clk_tb,
                reset => rst_tb,
                o => o_tb,
                err => err_tb
            );

        test_proc: process(clk_tb)
            variable t : integer := 0;
            begin
            if (rising_edge(clk_tb)) then
                case(t) is 
                
-- NOTE: each input is given after 7 ns, without loss of generality, to better visualize
-- the instant at which a certain input is actually read. This is because if an input is given
-- precisely on the clock edge, it will be seen only at the next edge. Moreover, having the signal
-- change at the same instant of the clock is not realistic.
                
                    when 0 => mode_tb <= '0' after 7 ns;
                    
--                  CASE 3 - R-R
--                  reset
                    when 1 => rst_tb <= '0' after 7 ns;
                    when 2 => rst_tb <= '1' after 7 ns;
                    
--                  right pulse
                    when 10 => mode_tb <= '1' after 7 ns;
                    when 11 => mode_tb <= '0' after 7 ns;
--                  right pulse after even spacing
                    when 13 => mode_tb <= '1' after 7 ns;
                    when 14 => mode_tb <= '0' after 7 ns;
                    
--                  -------------------------------------------

--                  CASE 4 - W
--                  reset
                    when 21 => rst_tb <= '0' after 7 ns;
                    when 22 => rst_tb <= '1' after 7 ns;
                    
--                  wrong pulse - 2 clocks
                    when 30 => mode_tb <= '1' after 7 ns;
                    when 32 => mode_tb <= '0' after 7 ns;

--                  -------------------------------------------

--                  CASE 5 - W
--                  reset
                    when 41 => rst_tb <= '0' after 7 ns;
                    when 42 => rst_tb <= '1' after 7 ns;
                    
--                  wrong pulse - 5 clocks
                    when 50 => mode_tb <= '1' after 7 ns;
                    when 55 => mode_tb <= '0' after 7 ns;
                    
--                  -------------------------------------------

--                  CASE 7 - R-W
--                  reset
                    when 61 => rst_tb <= '0' after 7 ns;
                    when 62 => rst_tb <= '1' after 7 ns;

--                  right pulse
                    when 66 => mode_tb <= '1' after 7 ns;
                    when 67 => mode_tb <= '0' after 7 ns;
                    
--                  wrong pulse - 5 clocks
                    when 70 => mode_tb <= '1' after 7 ns;
                    when 75 => mode_tb <= '0' after 7 ns;
                    
--                  -------------------------------------------

--                  CASE 8 - W-R
--                  reset
                    when 81 => rst_tb <= '0' after 7 ns;
                    when 82 => rst_tb <= '1' after 7 ns;
                    
--                  wrong pulse - 2 clocks
                    when 90 => mode_tb <= '1' after 7 ns;
                    when 92 => mode_tb <= '0' after 7 ns;  
                    
--                  right pulse
                    when 96 => mode_tb <= '1' after 7 ns;
                    when 97 => mode_tb <= '0' after 7 ns;               
                                 
                                 
--                  -------------------------------------------

--                  CASE 9 - R-W-W-R
--                  reset
                    when 105 => rst_tb <= '0' after 7 ns;
                    when 106 => rst_tb <= '1' after 7 ns;

--                  right pulse
                    when 111 => mode_tb <= '1' after 7 ns;
                    when 112 => mode_tb <= '0' after 7 ns;   
                    
--                  wrong pulse - 3 clocks
                    when 114 => mode_tb <= '1' after 7 ns;
                    when 117 => mode_tb <= '0' after 7 ns;  
                    
--                  wrong pulse - 5 clocks
                    when 119 => mode_tb <= '1' after 7 ns;
                    when 124 => mode_tb <= '0' after 7 ns;  
                    
--                  right pulse after 1 clock cycle
                    when 125 => mode_tb <= '1' after 7 ns;
                    when 126 => mode_tb <= '0' after 7 ns;   
                    
--                  -------------------------------------------    
          
--                  CASE 2' - R-R
--                  reset
                    when 130 => rst_tb <= '0' after 7 ns;
                    when 131 => rst_tb <= '1' after 7 ns;
                    
--                  right pulse
                    when 140 => mode_tb <= '1' after 7 ns;
                    when 141 => mode_tb <= '0' after 7 ns;
--                  right pulse after 1 clock cycle
                    when 142 => mode_tb <= '1' after 7 ns;
                    when 143 => mode_tb <= '0' after 7 ns;
                    
--                  -------------------------------------------    
          
--                  CASE 6' - W-W
--                  reset
                    when 150 => rst_tb <= '0' after 7 ns;
                    when 151 => rst_tb <= '1' after 7 ns;
                    
--                  wrong pulse - 2 clocks
                    when 160 => mode_tb <= '1' after 7 ns;
                    when 162 => mode_tb <= '0' after 7 ns;
--                  right pulse - 5 clocks after 1 clock cycle
                    when 163 => mode_tb <= '1' after 7 ns;
                    when 168 => mode_tb <= '0' after 7 ns;       
--                  -------------------------------------------

--                  CASE 7' - R-W
--                  reset
                    when 180 => rst_tb <= '0' after 7 ns;
                    when 181 => rst_tb <= '1' after 7 ns;

--                  right pulse
                    when 190 => mode_tb <= '1' after 7 ns;
                    when 191 => mode_tb <= '0' after 7 ns;
                    
--                  wrong pulse - 5 clocks after one clock cycle
                    when 192 => mode_tb <= '1' after 7 ns;
                    when 197 => mode_tb <= '0' after 7 ns;
                    
--                  -------------------------------------------

--                  CASE 8' - W-R
--                  reset
                    when 210 => rst_tb <= '0' after 7 ns;
                    when 211 => rst_tb <= '1' after 7 ns;
                    
--                  wrong pulse - 2 clocks
                    when 220 => mode_tb <= '1' after 7 ns;
                    when 222 => mode_tb <= '0' after 7 ns;  
                    
--                  right pulse after 1 clock cycle
                    when 223 => mode_tb <= '1' after 7 ns;
                    when 224 => mode_tb <= '0' after 7 ns;               
                                                      
                    when others => null;
                end case;
                t := t+1;
            end if;
        end process;  
end test;