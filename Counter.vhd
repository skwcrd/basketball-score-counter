Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Counter is
Port(
	CLK,Rstb : in std_logic;
	iP1,iP2,iP3 : in std_logic;
	oDigit1,oDigit2 : out std_logic_vector(3 downto 0);
	oLED : out std_logic_vector(3 downto 0)
	---------- 100 Score/LED ----------
);
End Counter;

Architecture Behavioral of Counter is
	signal wDigit1,wDigit2 : std_logic_vector(3 downto 0);
	signal wScore : std_logic_vector(3 downto 0);
	signal rCnt : std_logic := '0';
Begin

	oDigit1 <= wDigit1;
	oDigit2 <= wDigit2;
	
	oLED <= wScore;
	
	u_Score : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			wDigit1 <= (others => '0');
			wDigit2 <= (others => '0');
			rCnt <= '0';
		elsif(rising_edge(CLK)) then
			if(wScore="1111" and wDigit1>=9 and wDigit2>=9) then
				wDigit1 <= "1001";
				wDigit2 <= "1001";
			else
				if(wDigit1>9) then
					wDigit1 <= (others => '0');
				elsif(rCnt='1') then
					wDigit1 <= wDigit1 + 1;
					rCnt <= '0';
				else
					wDigit1 <= wDigit1;
				end if;
				
				if(iP1='1') then
					if(wDigit2>=9) then
						wDigit2 <= wDigit2 - 9;
						rCnt <= '1';
					else
						wDigit2 <= wDigit2 + 1;
						rCnt <= '0';
					end if;
				elsif(iP2='1') then
					if(wDigit2>=8) then
						wDigit2 <= wDigit2 - 8;
						rCnt <= '1';
					else
						wDigit2 <= wDigit2 + 2;
						rCnt <= '0';
					end if;
				elsif(iP3='1') then
					if(wDigit2>=7) then
						wDigit2 <= wDigit2 - 7;
						rCnt <= '1';
					else
						wDigit2 <= wDigit2 + 3;
						rCnt <= '0';
					end if;
				else
					wDigit2 <= wDigit2;
				end if;
			end if;
		end if;
	end Process;
	
	u_OverScore : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			wScore <= (others => '0');
		elsif(rising_edge(CLK)) then
			if(wDigit1>9) then
				wScore <= wScore(2 downto 0) & '1';
			else
				wScore <= wScore;
			end if;
		end if;
	end Process;

End Behavioral;
