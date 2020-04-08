library IEEE;
use IEEE.std_logic_1164.all;

entity pulsegen is
    port(
        m : in std_logic;
        clock : in std_logic;
        reset : in std_logic;
        o : out std_logic;
        err : out std_logic);
end pulsegen;

architecture rtl of pulsegen is

--  including d-flip-flop component
    component dff is
        port(
            d: in std_logic;
            clk: in std_logic;
            rst: in std_logic;
            q: out std_logic);
    end component;
    
--  defining all the needed signals   
    signal m_0 : std_logic;
    signal m_1 : std_logic;
    signal neg_edge : std_logic;
    signal long_pulse : std_logic;
    signal right_pulse : std_logic;
    signal last_long_pulse : std_logic;
    signal error_in : std_logic;
    signal error : std_logic;
    signal mode_in : std_logic;
    signal mode : std_logic;
    signal outp_in : std_logic;
    signal outp : std_logic;
    signal outp_mux_in : std_logic_vector(1 downto 0);
    
begin
--  mapping each register's port to the signals of the pulse generator
    m_0_reg:dff
        port map(
            d => m,
            clk => clock,
            rst => reset,
            q => m_0
        );
        
    m_1_reg:dff
        port map(
            d => m_0,
            clk => clock,
            rst => reset,
            q => m_1
        );
        
    last_long_pulse_reg:dff
        port map(
            d => long_pulse,
            clk => clock,
            rst => reset,
            q => last_long_pulse
        );
     
    error_reg:dff
        port map(
            d => error_in,
            clk => clock,
            rst => reset,
            q => error
        );
        
    mode_reg:dff
        port map(
            d => mode_in,
            clk => clock,
            rst => reset,
            q => mode
        );
        
    outp_reg:dff
        port map(
            d => outp_in,
            clk => clock,
            rst => reset,
            q => outp
        );
        
    error_out_reg:dff
        port map(
            d => error,
            clk => clock,
            rst => reset,
            q => err
        );
        
--  neg_edge detects a negative edge on the input, checking the current and previous value of the input
    neg_edge <= m_1 and not(m_0);

--  long_pulse detects a pulse longer than one clock cycle
    long_pulse <= m_0 and m_1;
    
--  right_pulse checks if the last pulse given to the input is good or not.
--  It checks if a negative edge is found and if it's not associated to a long pulse
    right_pulse <= neg_edge and not(last_long_pulse);

--  error_in is the input of error_reg register. It resets the error register if a good pulse is found,
--  or else keeps the previous value of the error signal or sets the error register to one if a long pulse is detected
    error_in <= '0' when right_pulse = '1' else
                long_pulse or error;
            
--  mode_in is the input of mode_reg register. It switches when a right pulse is detected, else it makes the mode_reg to
--  keep the same value
    mode_in <= not(mode) when right_pulse = '1' else
               mode;
    
--  outp_mux_in is the input to the multiplexer before the outp_reg register. The most significant bit is the error signal
    outp_mux_in <= error & mode;
    
--  outp_in is the input of outp_reg register. If no error is found: if the mode of the system is '0', then the output is kept
--  constant, otherwise the output is swiched at each clock cycle. If an error is detected, the output goes to '0'.
    outp_in <= outp when outp_mux_in = "00" else
               not(outp) when outp_mux_in = "01" else
               '0';

--  the output of the device is the output of the outp_reg register
    o <= outp;
        
end rtl;
