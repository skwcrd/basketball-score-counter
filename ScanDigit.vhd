Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity ScanDigit is
Port(
	CLK : in std_logic;
	Rstb : in std_logic;
	i1ms : in std_logic;
	iDigit1 : in std_logic_vector(3 downto 0);
	iDigit2 : in std_logic_vector(3 downto 0);
	iDigit3 : in std_logic_vector(3 downto 0);
	iDigit4 : in std_logic_vector(3 downto 0);
	oDigit : out std_logic_vector(3 downto 0);
	oData : out std_logic_vector(3 downto 0)
);
End ScanDigit;

Architecture Behavioral of ScanDigit is
	signal rCnt : std_logic_vector(3 downto 0);
	signal rShift : std_logic_vector(3 downto 0);
Begin

	oDigit <= rShift;
	
	oData <= iDigit4 when rShift="0111" else
				iDigit3 when rShift="1011" else
				iDigit2 when rShift="1101" else
				iDigit1;
	
	u_rCnt : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			rCnt <= (others => '0');
			rShift <= "0111";
		elsif(rising_edge(CLK)) then
			if(rCnt=4 and i1ms='1') then
				rCnt <= (others => '0');
				rShift <= rShift(0) & rShift(3 downto 1);
			elsif(i1ms = '1') then
				rCnt <= rCnt + 1;
				rShift <= rShift;
			else
				rCnt <= rCnt;
				rShift <= rShift;
			end if;
		end if;
	end Process;

End Behavioral;

