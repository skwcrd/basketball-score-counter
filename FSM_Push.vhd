Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity FSM_Push is
Port(
	CLK,Rstb : in std_logic;
	I : in std_logic;
	iPush1,iPush2,iPush3 : in std_logic;
	oT1Push1,oT1Push2,oT1Push3 : out std_logic;
	oT2Push1,oT2Push2,oT2Push3 : out std_logic
);
End FSM_Push;

Architecture Behavioral of FSM_Push is
	type State_Type is (S1,S2);
	signal curr_state,next_state : State_Type;
Begin

	---------- REGISTOR STATE ----------
	u_rState : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			curr_state <= S1;
		elsif(rising_edge(CLK)) then
			curr_state <= next_state;
		else
			curr_state <= curr_state;
		end if;
	End Process;
	
	---------- CHANGE STATE ----------
	u_State : Process(curr_state,I)
	Begin
		case curr_state is
			when S1 => 	if(I='1') then
								next_state <= S2;
							else
								next_state <= S1;
							end if;
				
			when S2 => 	if(I='1') then
								next_state <= S1;
							else
								next_state <= S2;
							end if;
				
			when others => next_state <= S1;
		end case;
	End Process;
	
	---------- OUTPUT STATE DIGIT ----------
	u_oState : Process(CLK)
	Begin
		if(rising_edge(CLK)) then
			case curr_state is
				when S1 =>	if(iPush1='1' or iPush2='1' or iPush3='1') then
									oT1Push1 <= iPush1;
									oT1Push2 <= iPush2;
									oT1Push3 <= iPush3;
									oT2Push1 <= '0';
									oT2Push2 <= '0';
									oT2Push3 <= '0';
								else
									oT1Push1 <= '0';
									oT1Push2 <= '0';
									oT1Push3 <= '0';
									oT2Push1 <= '0';
									oT2Push2 <= '0';
									oT2Push3 <= '0';
								end if;
								
				when S2 =>	if(iPush1='1' or iPush2='1' or iPush3='1') then
									oT2Push1 <= iPush1;
									oT2Push2 <= iPush2;
									oT2Push3 <= iPush3;
									oT1Push1 <= '0';
									oT1Push2 <= '0';
									oT1Push3 <= '0';
								else
									oT2Push1 <= '0';
									oT2Push2 <= '0';
									oT2Push3 <= '0';
									oT1Push1 <= '0';
									oT1Push2 <= '0';
									oT1Push3 <= '0';
								end if;
			end case;
		end if;
	End Process;

End Behavioral;

