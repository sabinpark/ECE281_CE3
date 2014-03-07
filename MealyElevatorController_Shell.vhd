----------------------------------------------------------------------------------
-- Company: USAFA/DFEC
-- Engineer: Silva
-- 
-- Create Date:    10:33:47 07/07/2012 
-- Design Name: 
-- Module Name:    MooreElevatorController_Silva - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MealyElevatorController_Shell is
    Port ( clk 		: in  STD_LOGIC;
           reset 		: in  STD_LOGIC;
           stop 		: in  STD_LOGIC;
           up_down 	: in  STD_LOGIC;
           floor 		: out STD_LOGIC_VECTOR (3 downto 0);
			  nextfloor : inout std_logic_vector (3 downto 0));
end MealyElevatorController_Shell;

architecture Behavioral of MealyElevatorController_Shell is

type floor_state_type is (floor1, floor2, floor3, floor4);

signal floor_state : floor_state_type;

begin

---------------------------------------------------------
--Code your Mealy machine next-state process below
--Question: Will it be different from your Moore Machine?
--Answer: Yes
---------------------------------------------------------
floor_state_machine: process(clk, stop)
begin
--Insert your state machine below:
	-- this is gonna be asynchronous
	
	-- going to go back to floor 1
	if reset='1' then
			floor_state <= floor1;
	end if;
	
	-- on the rising edge and not stopping
	if rising_edge(clk) and stop='0' then  
			case floor_state is
				--when our current state is floor1
				when floor1 =>
					--if up_down is set to "go up" we want to go to floor2
					if (up_down='1') then 
						floor_state <= floor2;
					--otherwise we're going to stay at floor1
					else
						floor_state <= floor1;
					end if;
				--when our current state is floor2
				when floor2 => 
					--if up_down is set to "go up" we want to go to floor3
					if (up_down='1') then 
						floor_state <= floor3; 			
					--if up_down is set to "go down" we want to go to floor1
					elsif (up_down='0' and stop='0') then 
						floor_state <= floor1;
					--otherwise we're going to stay at floor2
					else
						floor_state <= floor2;
					end if;
				--when our current state is floor3
				when floor3 =>
					--if up_down is set to "go up" we want to go to floor4
					if (up_down='1' and stop ='0') then 
						floor_state <= floor4;
					--if up_down is set to "go down" we want to go to floor2
					elsif (up_down='0' and stop='0') then 
						floor_state <= floor2;
					--otherwise stat at floor3
					else
						floor_state <= floor3;
					end if;
				--when our current state is floor4
				when floor4 =>
					--if up_down is set to "go down" we want to go floor3
					if (up_down='0' and stop='0') then 
						floor_state <= floor3;
					--otherwise remain at floor4
					else 
						floor_state <= floor4;	
					end if;
				
				--This line accounts for phantom states
				when others =>
					floor_state <= floor1;
			end case;
		end if;
end process;

-----------------------------------------------------------
--Code your Ouput Logic for your Mealy machine below
--Remember, now you have 2 outputs (floor and nextfloor)
-----------------------------------------------------------
floor <= nextFloor when (stop = '0');
nextfloor <= "0001" when (floor_state = floor1) else
				 "0010" when (floor_state = floor2) else
				 "0011" when (floor_state = floor3) else
				 "0100" when (floor_state = floor4) else
				 "0001";

end Behavioral;

