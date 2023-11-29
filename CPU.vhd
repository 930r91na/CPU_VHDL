library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
    port (
	  -- inputs
	  clk, reset: in std_logic;
	  from_memory: in std_logic_vector (7 downto 0);

	  
	  --outputs
	  address, to_memory: out std_logic_vector (7 downto 0);
	  iwrite: out std_logic
    );
end CPU;

architecture ARCH_CPU of CPU is
 -- Declare signals for interconnecting Control Unit and Data Path
    signal IR : std_logic_vector(7 downto 0);
    signal CCR_Result : std_logic_vector(3 downto 0);
    signal IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load: std_logic;
    signal ALU_Sel: std_logic_vector(2 downto 0);
    signal Bus1_Sel, Bus2_Sel: std_logic_vector(1 downto 0);

begin
	-- CONNECT DATAPATH AND CONTROL UNIT 

	ControlUnit_Instance: entity work.ControlUnit
    port map (
        clk => clk,  -- Assuming clk is a std_logic_vector, otherwise, you might need to convert it
        rst => reset,  -- Assuming rst is a std_logic_vector, otherwise, you might need to convert it
        IR => IR,
        CCR_Result => CCR_Result,
        iwrite => iwrite,
        IR_Load => IR_Load,
        MAR_Load => MAR_Load,
        PC_Load => PC_Load,
        PC_Inc => PC_Inc,
        A_Load => A_Load,
        B_Load => B_Load,
        CCR_Load => CCR_Load,
        ALU_Sel => ALU_Sel,
        Bus1_Sel => Bus1_Sel,
        Bus2_Sel => Bus2_Sel
    );
	 
    -- Instantiate the Data Path
    DataPath_Instance: entity work.DataPath
    port map (
        clk => clk,  -- Connect clk directly if it's a std_logic
        reset => reset,  -- Connect reset directly if it's a std_logic
        from_memory => from_memory,
        IR_Load => IR_Load,
        MAR_Load => MAR_Load,
        PC_Load => PC_Load,
        PC_Inc => PC_Inc,
        A_Load => A_Load,
        B_Load => B_Load,
        CCR_Load => CCR_Load,
        ALU_Sel => ALU_Sel,
        Bus1_Sel => Bus1_Sel,
        Bus2_Sel => Bus2_Sel,
        address => address,
        to_memory => to_memory,
        IR => IR,
        CCR_Result => CCR_Result
    );
end ARCH_CPU;
