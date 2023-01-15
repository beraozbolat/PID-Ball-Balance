LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY servo IS
    PORT (
        clk : IN STD_LOGIC;
        open_i : IN STD_LOGIC;
        pwm_o : OUT STD_LOGIC;
        angle_o : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        is_open_o : OUT STD_LOGIC;
        is_close_o : OUT STD_LOGIC
    );
END servo;

ARCHITECTURE Behavioral OF servo IS
    
    CONSTANT step : INTEGER := 1; -- angle step for opening/closing 
    
    SIGNAL counter : STD_LOGIC_VECTOR(27 DOWNTO 0); -- step delay counter
    SIGNAL angle : INTEGER RANGE 0 TO 127 := 90; -- cuurent angle of barrier arm
    SIGNAL angle_a : STD_LOGIC_VECTOR(6 DOWNTO 0); -- std vector of angle

    COMPONENT pwm IS
        PORT (
            clk : IN STD_LOGIC;
            angle_i : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            pwm_o : OUT STD_LOGIC
        );

    END COMPONENT;

BEGIN

    p1 : pwm
    PORT MAP(
        clk => clk,
        angle_i => angle_a,
        pwm_o => pwm_o
    );
    
    angle_a <= STD_LOGIC_VECTOR(to_unsigned(angle, angle_a'length));
    angle_o <= angle_a;

    PROCESS (clk) BEGIN
        IF (rising_edge(clk)) THEN
            counter <= counter + 1;
        END IF;
    END PROCESS;

    PROCESS (counter(20)) BEGIN

        IF (rising_edge(counter(20))) THEN
            IF (open_i = '1') THEN
                IF (angle < 90) THEN
                    angle <= angle + 1;
                END IF;
            ELSE
                IF (angle > 0) THEN
                    angle <= angle - 1;
                END IF;
            END IF;
            IF (angle = 90) THEN
                is_open_o <= '1';
            ELSE
                is_open_o <= '0';
            END IF;

            IF (angle = 0) THEN
                is_close_o <= '1';
            ELSE
                is_close_o <= '0';
            END IF;
        END IF;

    END PROCESS;
END Behavioral;
