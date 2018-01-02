Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity ScoreTop is
Port(
	CLK,Rstb : in std_logic;
	iPush1,iPush2,iPush3 : in std_logic;
	Change : in std_logic;
	oLEDT1 : out std_logic_vector(3 downto 0);
	oLEDT2 : out std_logic_vector(3 downto 0);
	oBCD : out std_logic_vector(6 downto 0);
	com : out std_logic_vector(3 downto 0)
);
End ScoreTop;

Architecture Structural of ScoreTop is
	
	Component CLK1ms is
	Port(
		CLK : in std_logic;
		Rstb : in std_logic;
		o1ms : out std_logic
	);
	End Component CLK1ms;
	
	Component CLK1s is
	Port(
		CLK : in std_logic;
		Rstb : in std_logic;
		i1ms : in std_logic;
		o1s : out std_logic
	);
	End Component CLK1s;
	
	Component Debouce is
	Port(
		CLK : in std_logic;
		Rstb : in std_logic;
		i1ms : in std_logic;
		I : in std_logic;
		O : out std_logic
	);
	End Component Debouce;
	
	Component ScanDigit is
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
	End Component ScanDigit;
	
	Component BCD is
	Port(
		I : in std_logic_vector(3 downto 0);
		O : out std_logic_vector(6 downto 0)
	);
	End Component BCD;
	
	Component FSM_Push is
	Port(
		CLK,Rstb : in std_logic;
		I : in std_logic;
		iPush1,iPush2,iPush3 : in std_logic;
		oT1Push1,oT1Push2,oT1Push3 : out std_logic;
		oT2Push1,oT2Push2,oT2Push3 : out std_logic
	);
	End Component FSM_Push;
	
	Component FSM_COM is
	Port(
		CLK,Rstb : in std_logic;
		i1s : in std_logic;
		I : in std_logic;
		iCOM : in std_logic_vector(3 downto 0);
		com : out std_logic_vector(3 downto 0)
	);
	End Component FSM_COM;
	
	Component Counter is
	Port(
		CLK,Rstb : in std_logic;
		iP1,iP2,iP3 : in std_logic;
		oDigit1,oDigit2 : out std_logic_vector(3 downto 0);
		oLED : out std_logic_vector(3 downto 0)
	);
	End Component Counter;
	
	signal w1ms,w1s : std_logic;
	signal wT1Push1,wT1Push2,wT1Push3 : std_logic;
	signal wT2Push1,wT2Push2,wT2Push3 : std_logic;
	signal wData : std_logic_vector(3 downto 0);
	signal wDigit1,wDigit2,wDigit3,wDigit4 : std_logic_vector(3 downto 0);
	signal wPush1,wPush2,wPush3 : std_logic;
	signal wChange : std_logic;
	signal wCOM : std_logic_vector(3 downto 0);
Begin

	u_CLK1ms : CLK1ms
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		o1ms	=> w1ms
	);
	
	u_CLK1s : CLK1s
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1ms	=> w1ms,
		o1s	=> w1s
	);
	
	u_Push1 : Debouce
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1ms	=> w1ms,
		I		=> iPush1,
		O		=> wPush1
	);
	
	u_Push2 : Debouce
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1ms	=> w1ms,
		I		=> iPush2,
		O		=> wPush2
	);
	
	u_Push3 : Debouce
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1ms	=> w1ms,
		I		=> iPush3,
		O		=> wPush3
	);
	
	u_Team1 : Counter
	Port Map(
		CLK		=> CLK,
		Rstb		=> Rstb,
		iP1		=> wT1Push1,
		iP2		=> wT1Push2,
		iP3		=> wT1Push3,
		oDigit1	=> wDigit1,
		oDigit2	=> wDigit2,
		oLED		=> oLEDT1
	);
	
	u_Team2 : Counter
	Port Map(
		CLK		=> CLK,
		Rstb		=> Rstb,
		iP1		=> wT2Push1,
		iP2		=> wT2Push2,
		iP3		=> wT2Push3,
		oDigit1	=> wDigit3,
		oDigit2	=> wDigit4,
		oLED		=> oLEDT2
	);
	
	u_Change : Debouce
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1ms	=> w1ms,
		I		=> Change,
		O		=> wChange
	);
	
	u_FSMpush : FSM_Push
	Port Map(
		CLK		=> CLK,
		Rstb		=> Rstb,
		I			=> wChange,
		iPush1	=> wPush1,
		iPush2	=> wPush2,
		iPush3	=> wPush3,
		oT1Push1	=> wT1Push1,
		oT1Push2	=> wT1Push2,
		oT1Push3	=> wT1Push3,
		oT2Push1	=> wT2Push1,
		oT2Push2	=> wT2Push2,
		oT2Push3	=> wT2Push3
	);
	
	u_FSMcom : FSM_COM
	Port Map(
		CLK	=> CLK,
		Rstb	=> Rstb,
		i1s	=> w1s,
		I		=> wChange,
		iCOM	=> wCOM,
		com	=> com
	);
	
	u_ScanDigit : ScanDigit
	Port Map(
		CLK		=> CLK,
		Rstb		=> Rstb,
		i1ms		=> w1ms,
		iDigit1	=> wDigit1,
		iDigit2	=> wDigit2,
		iDigit3	=> wDigit3,
		iDigit4	=> wDigit4,
		oDigit	=> wCOM,
		oData		=> wData
	);
	
	u_BCD : BCD
	Port Map(
		I	=> wData,
		O	=> oBCD
	);

End Structural;
