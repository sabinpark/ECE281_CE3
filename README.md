ECE281_CE3
==========

Sabin's CE 3

# Moore Elevator Controller
## Moore Shell
Writing the code for the rest of the case statements (for floors 3 and 4) was not too difficult.  I used if statements to check the values of the inputs, which would determine what the outputs would be.

The self-explanatory vhdl code is shown below:

```vhdl
 	when floor3 =>
	  	--if up_down is set to "go up" and stop is set to "don't stop" we want to go to floor4
	  	if (up_down='1' and stop ='0') then 
	  		floor_state <= floor4;
	  	--if up_down is set to "go down" and stop is set to "don't stop" we want to go to floor2
	  	elsif (up_down='0' and stop='0') then 
	  		floor_state <= floor2;
	  	--otherwise stat at floor3
	  	else
	  		floor_state <= floor3;
	  	end if;
	when floor4 =>
  		--if up_down is set to "go down" and stop is set to "don't stop", we want to go down to floor3
  		if (up_down='0' and stop='0') then 
  			floor_state <= floor3;
  		--otherwise remain at floor4
  		else 
  			floor_state <= floor4;	
  		end if;
```

The output logic signal assignments were set appropriately depending on what the floor_state value was:

```vhdl
 	floor <= "0001" when (floor_state = floor1) else
      		 "0010" when (floor_state = floor2) else
      		 "0011" when (floor_state = floor3) else
      		 "0100" when (floor_state = floor4) else
      		 "0001";
```

After succesfully checking my syntax, I was ready to create the testbench.

## Moore Testbench
To start at floor 1, I set *reset* to 1.  I then waited for 2 clock periods to allow the simulation to record the results.  I then set *reset* back to 0 to keep the simulation from continuing to read the current floor to be floor 1.
```vhdl
	reset <= '1';
	wait for clk_period*2;
	reset <= '0';
```

Next, I set *up_down* to 1, which means that the elevator will be moving upwards.

For floor 2, I set *stop* to 0, waited for a clock period, then set *stop* to 1.  I waited for 2 clock periods to record the simulation values.  The same thing was used for floor 3 and floor 4.
```vhdl
	-- Floor 2 to Floor 3
	stop <= '0';
	wait for clk_period;
	stop <= '1';
	assert (floor = "0011")
			report "Floor 3 expected"
	severity error;
	wait for clk_period*2;
```

Once I reached floor 4, I set *up_down* and *stop* back to 0.  I then waited a clock period before checking that the floor level value went down back to floor 1.  From here, I called *wait* until the program terminated.  I noted that the changes from floor 4 to 3, from floor 3 to 2, and from floor 2 to 1 all happened during the rising edge of the clock.

I then added assert statements to turn the testbench into a self-checking testbench.  After each value change, I inserted an assert statement that checked whether the floor it should be one matches the floor it is on (all based on the 4-bit floor values).  I did not get an error, proving that the simulation functioned as it should have.  To be sure, I changed one of the checking values to "1111" instead of "0010" and I did receive an error which told me where to check for the error and what the expected floor level was.  

### Simulation Results
![alt text](https://raw.github.com/sabinpark/ECE281_CE3/master/Moore_Simulation_Results.PNG "Moore Testbench Simulation Results")



# Mealy Elevator Controller
## Mealy Shell

*UPDATE*: I changed the mealy shell so that instead of having the rising_edge(clk) "AND-ed" together with a signal input, the code would test each statement separately, preventing potential errors for when I program the nexys2_shell.

For the Mealy, I realized that instead of having the current state alone drive the outputs, I had to have the current state and the current inputs drive the outputs.  I accomplished this by adding *up_down* and *stop* to the sensitivity list.  

The process, *floor_state_machine* was essentially kept the same; with differences only within the structure of the if statements.

Below is the changed sensitivity list:
```vhdl
	floor_state_machine: process(up_down, stop, clk)
```
Since the sensitivity list contains the clock and other signal inputs as well, the program will change from being synchronous to asynchronous.

At the end, the output logic was also changed to account for the output, *next_floor*.  Depending on the value of *up_down*, *next_floor* would equal the floor right above or right below *floor*.  Of course, if the current floor is floor 1 and *up_down* is 0, then *next_floor* would be set to the bottom-most floor, floor 1.  Likewise, if the current floor is floor 4 and *up_down* is 1, then *next_floor* would be set to the top-most floor, floor 4. 

```vhdl
    nextfloor <= "0001" when (floor_state = floor1 and up_down = '0') else
		 "0001" when (floor_state = floor2 and up_down = '0') else
		 "0010" when (floor_state = floor1 and up_down = '1') else
		 "0010" when (floor_state = floor3 and up_down = '0') else
		 "0011" when (floor_state = floor2 and up_down = '1') else
		 "0011" when (floor_state = floor4 and up_down = '0') else
		 "0100" when (floor_state = floor3 and up_down = '1') else
		 "0100" when (floor_state = floor4 and up_down = '1') else
		 "0001";
```

Other than what was mentioned above, the code for the MEALY was very similar to the MOORE.

## Mealy Testbench
The testbench was also very similar to the MOORE testbench.  The biggest difference was that I had to account for the signal, *nextfloor*.  Again, since the code was essentially the same, I was able to reuse the assert statements.  Fortunately, the console did not print out any errors.  This showed that the design functioned as it was supposed to.  Furthermore, I doublechecked the results manually, and the results were correct.

### Update
I changed the testbench to account for the next floor as well.

### Simulation Results
![alt text](https://raw.github.com/sabinpark/ECE281_CE3/master/Mealy_Simulation_Results.PNG "Mealy Testbench Simulation Results")

# Questions/Answers
All of the questions were answered within the code.  However, I will add the questions and answers here as well.

### Q1
Q: is reset synchronous or asynchronous?

A: synchronous because it is dependent on the clock

### Q2
Q: if up_down is set to "go up" and stop is set to "don't stop" which floor do we want to go to?

A: if you're on floors 1, 2, or 3, then go one floor up; if you're on floor 4, remain on floor 4

### Q3
Q: if up_down is set to "go down" and stop is set to "don't stop" which floor do we want to go to?

A: if you're on floors 2, 3, or 4, then go one floor down; if you're on floor 1, remain on floor 1

### Q4
Q: will the Mealy machine be different from the Moore machine?

A: yes, because the mealy's output logic depends on both the current state and the current inputs., while the moore takes in only the current states


# Documentation
Testbench: Cadet Bodin pointed out that it would be simpler for now to check each floor value with the expected value manually instead of using a for loop.

Mealy Shell:  Cadet Wooden helped me by pointing out that I needed another signal, *next_floor_state* to drive the state of the program as well.  He told me the usefulness of separating the mealy process into two different processes.  *UPDATE* I ended up not using the *next_floor_state* signal.  
