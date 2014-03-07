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
For the Mealy, I realized that instead of having the current state alone drive the outputs, I had to have the current state and the current inputs drive the outputs.  I accomplished this by including an AND with the check for a rising edge.  Specifically, I made the MEALY shell sensitive to the signal *stop*.

```vhdl
	if reset='1' then
		floor_state <= floor1;
	end if;
	
	-- on the rising edge and not stopping
	if rising_edge(clk) and stop='0' then  
		case floor_state is
			--when our current state is floor1	
			when floor1 =>
			
			...  -- same as the code above
```
By checking the rising edge AND the value of stop, the program will change from being synchronous to asynchronous.  This is a characteristic of the mealy shell.  Also note that the first if statement checks for the value of *reset* even before checking for the rising edge.

At the end, the output logic was also changed to account for the output, *nextFloor*.  *floor* would take in the value of *nextfloor* when the value of stop is 0, meaning that the elevator is moving.  Right after, *nextfloor* takes the value of the floor number depending on the signal, *floor_state*.

```vhdl
	floor <= nextFloor when (stop = '0');
	nextfloor <= "0001" when (floor_state = floor1) else
		"0010" when (floor_state = floor2) else
		"0011" when (floor_state = floor3) else
		"0100" when (floor_state = floor4) else
		"0001";
```

One thing I had to accomodate was to make nextfloor into an *INOUT* instead of an *OUT* signal.  This was necessary because I set the value of *floor* to *nextfloor*, which was not possible with an *OUT*.

Other than what was mentioned above, the code for the MEALY was very similar to the MOORE.

## Mealy Testbench
The testbench was also very similar to the MOORE testbench.  The biggest difference was that I had to account for the signal, *nextfloor*.  Again, since the code was essentially, the same, I was able to reuse the assert statements.  Fortunately, the console did not print out any errors.  This showed that the design funcioned as it was supposed to.  Furthermore, I doublechecked the results manually, and the results were correct.

### Simulation Results
![alt text](https://raw.github.com/sabinpark/ECE281_CE3/master/Mealy_Simulation_Results.PNG "Mealy Testbench Simulation Results")


# Documentation:
Testbench: Cadet Bodin pointed out that it would be simpler for now to check each floor value with the expected value manually instead of using a for loop.  He also helped me with the testbench by pointing out that nextfloor should be an *INOUT* instead of *OUT*.  This got rid of my errors and allowed the simulation to run successfully.
