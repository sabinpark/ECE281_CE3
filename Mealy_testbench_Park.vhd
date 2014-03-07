--------------------------------------------------------------------------------
-- Company: 	USAFA
-- Engineer:  	Sabin Park
--
-- Create Date:   00:31:19 03/07/2014
-- Design Name:	CE3 Test Bench   
-- Module Name:   Mealy_testbench_Park.vhd
-- Description: 	Testbench for the Mealy Elevator Controller vhdl file
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Mealy_testbench_Park IS
END Mealy_testbench_Park;
 
ARCHITECTURE behavior OF Mealy_testbench_Park IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MealyElevatorController_Shell
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         stop : IN  std_logic;
         up_down : IN  std_logic;
         floor : OUT  std_logic_vector(3 downto 0);
         nextfloor : INOUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal stop : std_logic := '0';
   signal up_down : std_logic := '0';

 	--Outputs
   signal floor : std_logic_vector(3 downto 0);
   signal nextfloor : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MealyElevatorController_Shell PORT MAP (
          clk => clk,
          reset => reset,
          stop => stop,
          up_down => up_down,
          floor => floor,
          nextfloor => nextfloor
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
    begin
		
		report "Start of the MEALY simulation test";
		
      --wait for clk_period*2;

      -- insert stimulus here 
		
		-- Start at Floor 1
		reset <= '1';
		wait for clk_period*2;
		assert (floor = "0001")
				report "Floor 1 expected"
		severity error;
		reset <= '0';
		
		up_down <= '1';
		
		-- Floor 1 to Floor 2
		stop <= '0';
		wait for clk_period;
		stop <= '1';
		assert (floor = "0010")
				report "Floor 2 expected"
		severity error;
		wait for clk_period*2;
		
		-- Floor 2 to Floor 3
		stop <= '0';
		wait for clk_period;
		stop <= '1';
		assert (floor = "0011")
				report "Floor 3 expected"
		severity error;
		wait for clk_period*2;
		
		-- Floor 3 to Floor 4
		stop <= '0';
		wait for clk_period;
		stop <= '1';
		assert (floor = "0100")
				report "Floor 4 expected"
		severity error;
		wait for clk_period*2;
		
		-- Go back down to Floor 1
		up_down <= '0';
		stop <= '0';
		
		wait for clk_period;
		
		assert (floor = "0011")
				report "Floor 3 expected"
		severity error;
		wait for clk_period;
		
		assert (floor = "0010")
				report "Floor 2 expected"
		severity error;
		wait for clk_period;
		
		assert (floor = "0001")
				report "Floor 1 expected"
		severity error;
		
      wait;
   end process;

END;
