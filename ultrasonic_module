library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std;

entity ultrasonic is
        port(
        fpgaclk: in std_logic;
        pulse: in std_logic; -- echo
        triggerOut:out std_logic; -- trigger out
        sonuc:out std_logic;
        Var_yok : inout std_logic);
end entity;

architecture behaviour of ultrasonic is
component counter is

generic(n : positive :=10);
port( clk: in std_logic;
    enable : in std_logic;
    reset2 : in std_logic; -- active low
    counter_output: out std_logic_vector(n-1 downto 0));
end component;


component trigger_generator is
    port( clk: in std_logic;
    trigg : out std_logic);
end component;

--signal triggerOut: std_logic;
--signal distanceOut:std_logic(21 downto 0);
signal pulse_width: std_logic_vector(21 downto 0);
signal trigg:std_logic;
signal triggnot: std_logic;
signal Var_yok_reg: STD_LOGIC_VECTOR( 69 downto 0):="0000000000000000000000000000000000000000000000000000000000000000000000";


begin
triggnot <= not(trigg);
counter_echo_pulse :
counter generic map(22) 
        port map(clk => fpgaclk,
                 enable =>pulse,
                 reset2 => triggnot,
                 counter_output => pulse_width);

trigger_generation :
trigger_generator port map(fpgaclk,trigg);
Var_yok_detection: process(pulse_width)
begin
if(pulse_width < 55000) then
Var_yok <= '1';


else
Var_yok <= '0';



end if;
end process;
   
process(fpgaclk)
begin
    if fpgaclk'event and fpgaclk ='1' then
        Var_yok_reg<= Var_yok_reg(68 downto 0) & Var_yok ;
    end if;    
    
    
    if (Var_yok_reg = "1111111111111111111111111111111111111111111111111111111111111111111111") then
    sonuc <='0';    
    else 
    sonuc <='1';
    end if;
end process;
triggerOut <= trigg;

end architecture;
