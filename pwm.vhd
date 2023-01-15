LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pwm IS
	GENERIC (
		c_clkfreq : INTEGER := 100_000_000;
		c_pwmfreq : INTEGER := 50
	);
	PORT (
		clk : IN STD_LOGIC;
		angle_i : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		pwm_o : OUT STD_LOGIC
	);
END pwm;

ARCHITECTURE Behavioral OF pwm IS

	CONSTANT c_timerlim : INTEGER := c_clkfreq/c_pwmfreq;

	CONSTANT angle_0 : INTEGER := 54400;
--	CONSTANT angle_w: INTEGER:= CONV_INTEGER(angle_i);
	CONSTANT angle_90 : INTEGER := 147200;
	CONSTANT step : integer := (angle_90 - angle_0)/90;
--	CONSTANT step2 : integer := (angle_90 - angle_0)/90;
	SIGNAL hightime : INTEGER RANGE 0 TO c_timerlim := c_timerlim/2;
	SIGNAL timer : INTEGER RANGE 0 TO c_timerlim := 0;
BEGIN

	PROCESS (clk) BEGIN
		IF (rising_edge(clk)) THEN
			hightime <= (step) * CONV_INTEGER(angle_i) + angle_0;
			IF (hightime > angle_90) THEN
				hightime <= (angle_90);
			END IF;
			IF (timer = c_timerlim - 1) THEN --s1
				timer <= 0;
			ELSIF (timer < hightime) THEN --s2
				pwm_o <= '1';
				timer <= timer + 1;
			ELSE
				pwm_o <= '0'; --s3
				timer <= timer + 1;
			END IF;
		END IF;
	END PROCESS;
END Behavioral;
