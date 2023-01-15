----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2022 06:13:25
-- Design Name: 
-- Module Name: Topmodule - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Topmodule is
  Port (clk:in std_logic;
        Trigger_pwm: out std_logic;
        Echo_signal: in std_logic;
        Servo_pwm: out std_logic;
        Reset_stop: in std_logic );
end Topmodule;

architecture Behavioral of Topmodule is

component servo IS
    PORT (
        clk : IN STD_LOGIC;
        open_i : IN STD_LOGIC;
        pwm_o : OUT STD_LOGIC;
        angle_o : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        is_open_o : OUT STD_LOGIC;
        is_close_o : OUT STD_LOGIC
    );
END component;


component  ultrasonic is
        port(
        fpgaclk: in std_logic;
        pulse: in std_logic; -- echo
        triggerOut:out std_logic; -- trigger out
        sonuc:out std_logic;
        Var_yok : inout std_logic);
end component;

component ServoPWM is
    PORT (
        clk   : IN  STD_LOGIC;
        reset : IN  STD_LOGIC;
        pos   : IN  STD_LOGIC_VECTOR(6 downto 0);
        servo : OUT STD_LOGIC
    );
end component;

component ClockDivider2 is
    Port (
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        clk_out: out STD_LOGIC
    );
end component;

component ClockDivider is
    Port (
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        clk_out: out STD_LOGIC
    );
end component;



component sensor is
    Port ( led_representation : out std_logic_vector(7 downto 0);
         Trigg : out std_logic;
         Echo : in std_logic;
         clk : in std_logic;
         stop : in std_logic);
end component;
Signal Temporary_sensor_Data: std_logic_vector(7 downto 0);
Signal Servo_pwm_value: STD_LOGIC_VECTOR(6 downto 0);
Signal servo_pwm_degree: integer;
signal Slow_Clock_1: std_logic;
signal Slow_Clock_2: std_logic;
signal Var_yok_signal: std_logic;
signal var_Yok_Signal_2: std_logic;
signal degree90i: std_logic;
constant Middle: integer:= 25;
signal s1,s2,s3: std_logic;
signal angle_o_o:std_logic_vector(6 downto 0);
begin

                 
 var_yok: ultrasonic
    port map (
                fpgaclk => clk,
                pulse=>Echo_signal,
                triggerOut=>Trigger_pwm,
                sonuc =>var_Yok_Signal,
                Var_yok=>var_Yok_Signal_2);
 
 degree90_func: servo
 port map( clk=>clk,
           open_i=> degree90i,
           pwm_o =>Servo_pwm,
           angle_o =>angle_o_o,
           is_open_o =>s1,
           is_close_o=>s2);
 
 
Init: process(clk,Reset_stop)
    begin
        if rising_edge(clk) then
            if var_Yok_Signal_2 = '0' then
                degree90i <= '1';
            else
                degree90i <= '0';
            end if;
        end if ;
     end process;
 

end Behavioral;
