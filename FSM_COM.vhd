Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity FSM_COM is
Port(
	CLK,Rstb : in std_logic;
	i1ms : in std_logic;
	I : in std_logic;
	iCOM : in std_logic_vector(3 downto 0);
	com : out std_logic_vector(3 downto 0)
);
End FSM_COM;

Architecture Behavioral of FSM_COM is
	type State_Type is (S1,S2);
	signal curr_state,next_state : State_Type;
	signal rCnt : std_logic := '0';
	signal wCom : std_logic_vector(3 downto 0);
	signal rCnP : std_logic := '0';
	signal rCnt500ms : std_logic_vector(8 downto 0);
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
	com <= wCom;
	
	u_oState : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			rCnt <= '0';
			wCom <= (others => '0');
		elsif(rising_edge(CLK)) then
			case curr_state is
				when S1 =>	if(rCnt='0') then
									wCom <= iCOM(3 downto 2) & "11";
									if(rCnP='1') then
										rCnt <= '1';
									else
										rCnt <= '0';
									end if;
								elsif(rCnt='1') then
									wCom <= iCOM;
									if(rCnP='1') then
										rCnt <= '0';
									else
										rCnt <= '1';
									end if;
								else
									rCnt <= rCnt;
									wCom <= wCom;
								end if;
								
				when S2 =>	if(rCnt='0') then
									wCom <= "11" & iCOM(1 downto 0);
									if(rCnP='1') then
										rCnt <= '1';
									else
										rCnt <= '0';
									end if;
								elsif(rCnt='1') then
									wCom <= iCOM;
									if(rCnP='1') then
										rCnt <= '0';
									else
										rCnt <= '1';
									end if;
								else
									rCnt <= rCnt;
									wCom <= wCom;
								end if;
			end case;
		end if;
	End Process;
	
	u_rCnt : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			rCnP <= '0';
		elsif(rising_edge(CLK)) then
			if(rCnt500ms=499 and i1ms='1') then
				rCnt500ms <= (others => '0');
				rCnP <= '1';
			elsif(i1ms='1') then
				rCnt500ms <= rCnt500ms + 1;
				rCnP <= '0';
			else
				rCnt500ms <= rCnt500ms;
				rCnP <= rCnP;
			end if;
		end if;
	end Process;

End Behavioral;

