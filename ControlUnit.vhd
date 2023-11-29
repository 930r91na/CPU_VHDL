library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit is
    port (
		--INPUT
        clk, rst : in STD_LOGIC;
        IR : in STD_LOGIC_VECTOR(7 downto 0);
		  CCR_Result : in STD_LOGIC_VECTOR(3 downto 0);
		 -- Outputs
        iwrite, IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load: out std_logic;
		  ALU_Sel: out std_logic_vector (2 downto 0);
		  Bus1_Sel, Bus2_Sel: out std_logic_vector(1 downto 0)
    );
end ControlUnit;

architecture arch_controlUnit of ControlUnit is 
	constant LDA_IMM : std_logic_vector(7 downto 0) := x"86";
	constant LDA_DIR : std_logic_vector(7 downto 0) := x"87";
	constant LDB_IMM : std_logic_vector(7 downto 0) := x"88";
	constant LDB_DIR : std_logic_vector(7 downto 0) := x"89";
	constant STA_DIR : std_logic_vector(7 downto 0) := x"96";
	constant STB_DIR : std_logic_vector(7 downto 0) := x"97";
	constant ADD_AB : std_logic_vector(7 downto 0) := x"42";
	constant BRA : std_logic_vector(7 downto 0) := x"20";
	constant BEQ : std_logic_vector(7 downto 0) := x"23";
	
	type state_type is (S_FETCH_0, S_FETCH_1, S_FETCH_2,
	S_DECODE_3,
	S_LDA_IMM_4, S_LDA_IMM_5, S_LDA_IMM_6,
	S_LDA_DIR_4, S_LDA_DIR_5, S_LDA_DIR_6, S_LDA_DIR_7, S_LDA_DIR_8,
	S_LDB_IMM_4, S_LDB_IMM_5, S_LDB_IMM_6,
	S_LDB_DIR_4, S_LDB_DIR_5, S_LDB_DIR_6, S_LDB_DIR_7, S_LDB_DIR_8,
	S_STA_DIR_4, S_STA_DIR_5, S_STA_DIR_6, S_STA_DIR_7,
	S_STB_DIR_4, S_STB_DIR_5, S_STB_DIR_6, S_STB_DIR_7,
	S_ADD_AB_4,
	S_BRA_4, S_BRA_5, S_BRA_6,
	S_BEQ_4, S_BEQ_5, S_BEQ_6, S_BEQ_7);
	signal current_state, next_state: state_type;
	begin
	STATE_MEMORY : process (clk, rst)
	begin 
		if (rst = '0') then 
			current_state <= S_FETCH_0;
		elsif (clk'event and clk = '1') then
			current_state <= next_state;
		end if; 
	end process;
	NEXT_STATE_LOGIC : process (current_state, IR, CCR_Result)
	begin
		if(current_state = S_FETCH_0) then 
			next_state <= S_FETCH_1; 
		elsif (current_state = S_FETCH_1) then 
			next_state <= S_FETCH_2; 
		elsif (current_state = S_FETCH_2) then 
			next_state <= S_DECODE_3;
		elsif (current_state = S_DECODE_3) then 
			if (IR = LDA_IMM) then 								 -- Load A Immediate
				next_state <= S_LDA_IMM_4;
			elsif(IR = LDA_DIR) then 							 -- Load A Direct
				next_state <= S_LDA_DIR_4; 
			elsif (IR = STA_DIR) then 							 -- Store A Direct
				next_state <= S_STA_DIR_4; 
			elsif (IR = LDB_IMM) then 							 -- Load B Immediate 
				next_state <= S_LDB_IMM_4; 
			elsif (IR = LDB_DIR) then 							 -- Load B Direct  
				next_state <= S_LDB_DIR_4; 
			elsif (IR = STB_DIR) then 							 -- Store B Direct
				next_state <= S_STB_DIR_4;	
			elsif (IR =  ADD_AB) then 							 -- ADD A and  B
				next_state <= S_ADD_AB_4; 
			elsif (IR = BRA) then 								 -- Branch Always 
				next_state <= S_BRA_4; 
			elsif (IR = BEQ and CCR_Result(2) = '1') then -- BEQ and Z=1
				next_state <= S_BEQ_4; 
			elsif	(IR = BEQ and CCR_Result(2) = '0') then -- BEQ and z=0 
				next_state <= S_BEQ_7; 
			else
				next_state <= S_FETCH_0;
			end if;
			
		elsif (current_state = S_LDA_IMM_4) then 
			next_state <= S_LDA_IMM_5; 
		elsif (current_state = S_LDA_IMM_5) then
			next_state <= S_LDA_IMM_6; 
		elsif (current_state = S_LDA_DIR_4) then 
			next_state <= S_LDA_DIR_5; 
		elsif (current_state = S_LDA_DIR_5) then
			next_state <= S_LDA_DIR_6;  
		elsif (current_state = S_LDA_DIR_6) then
			next_state <= S_LDA_DIR_7; 
		elsif (current_state = S_LDA_DIR_7) then
			next_state <= S_LDA_DIR_8; 
		elsif (current_state = S_STA_DIR_4) then 
			next_state <= S_STA_DIR_5; 
		elsif (current_state = S_STA_DIR_5) then
			next_state <= S_STA_DIR_6;  
		elsif (current_state = S_STA_DIR_6) then
			next_state <= S_STA_DIR_7; 
		elsif (current_state = S_LDB_IMM_4) then 
			next_state <= S_LDB_IMM_5; 
		elsif (current_state = S_LDB_IMM_5) then
			next_state <= S_LDB_IMM_6; 
		elsif (current_state = S_LDB_DIR_4) then 
			next_state <= S_LDB_DIR_5; 
		elsif (current_state = S_LDB_DIR_5) then
			next_state <= S_LDB_DIR_6;  
		elsif (current_state = S_LDB_DIR_6) then
			next_state <= S_LDB_DIR_7; 
		elsif (current_state = S_LDB_DIR_7) then
			next_state <= S_LDB_DIR_8; 
		elsif (current_state = S_STB_DIR_4) then 
			next_state <= S_STB_DIR_5; 
		elsif (current_state = S_STB_DIR_5) then
			next_state <= S_STB_DIR_6;  
		elsif (current_state = S_STB_DIR_6) then
			next_state <= S_STB_DIR_7; 
		elsif (current_state = S_BRA_4) then 
			next_state <= S_BRA_5; 
		elsif (current_state = S_BRA_5) then 
			next_state <= S_BRA_6; 
		elsif (current_state = S_BEQ_4) then 
			next_state <= S_BEQ_5; 
		elsif (current_state = S_BEQ_5) then 
			next_state <= S_BEQ_6; 
		else
			next_state <= S_FETCH_0;	
		end if; 
	end process; 
	OUTPUT_LOGIC : process (current_state) 
	begin 
		case current_state is 
			when S_FETCH_0 => 
				IR_Load <= '0';
				MAR_Load <= '1'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="01";
				iwrite <= '0';
			when S_FETCH_1 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '1'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="00"; --01
				iwrite <= '0';	
			when S_FETCH_2 =>
				IR_Load <= '1';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '1'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';
			when S_DECODE_3 =>
				if (IR = LDA_IMM) then
					IR_Load <= '0';
					MAR_Load <= '1'; 
					PC_Load <= '0'; 
					PC_Inc <= '0'; 
					A_Load <= '0';
					B_Load <= '0'; 
					ALU_Sel <= "000"; 
					CCR_Load <= '0';
					Bus1_Sel <= "00"; 
					Bus2_Sel <="01";
					iwrite <= '0';
				elsif (IR = LDA_DIR) then
					IR_Load <= '0';
					MAR_Load <= '1'; 
					PC_Load <= '0'; 
					PC_Inc <= '0'; 
					A_Load <= '0';
					B_Load <= '0'; 
					ALU_Sel <= "000"; 
					CCR_Load <= '0';
					Bus1_Sel <= "00"; 
					Bus2_Sel <="01";
					iwrite <= '0';
				elsif (IR = STA_DIR) then
					IR_Load <= '0';
					MAR_Load <= '1'; 
					PC_Load <= '0'; 
					PC_Inc <= '0'; 
					A_Load <= '0';
					B_Load <= '0'; 
					ALU_Sel <= "000"; 
					CCR_Load <= '0';
					Bus1_Sel <= "00"; 
					Bus2_Sel <="01";
					iwrite <= '0';
				elsif	(IR = LDB_IMM) then
					IR_Load <= '0';
					MAR_Load <= '1'; 
					PC_Load <= '0'; 
					PC_Inc <= '0'; 
					A_Load <= '0';
					B_Load <= '0'; 
					ALU_Sel <= "000"; 
					CCR_Load <= '0';
					Bus1_Sel <= "00"; 
					Bus2_Sel <="01";
					iwrite <= '0';
				elsif (IR = LDB_DIR) then
					IR_Load <= '0';
					MAR_Load <= '1'; 
					PC_Load <= '0'; 
					PC_Inc <= '0'; 
					A_Load <= '0';
					B_Load <= '0'; 
					ALU_Sel <= "000"; 
					CCR_Load <= '0';
					Bus1_Sel <= "00"; 
					Bus2_Sel <="01";
					iwrite <= '0';
				elsif (IR = STB_DIR) then
					IR_Load <= '0';
					MAR_Load <= '1'; 
					PC_Load <= '0'; 
					PC_Inc <= '0'; 
					A_Load <= '0';
					B_Load <= '0'; 
					ALU_Sel <= "000"; 
					CCR_Load <= '0';
					Bus1_Sel <= "00"; 
					Bus2_Sel <="01";
					iwrite <= '0';	
				elsif(IR = BRA) then 
					IR_Load <= '0';
					MAR_Load <= '1'; 
					PC_Load <= '0'; 
					PC_Inc <= '0'; 
					A_Load <= '0';
					B_Load <= '0'; 
					ALU_Sel <= "000"; 
					CCR_Load <= '0';
					Bus1_Sel <= "00"; 
					Bus2_Sel <="01";
					iwrite <= '0';	
				elsif (IR = BEQ and CCR_Result(2) = '0') then 
					IR_Load <= '0';
					MAR_Load <= '1'; 
					PC_Load <= '0'; 
					PC_Inc <= '0'; 
					A_Load <= '0';
					B_Load <= '0'; 
					ALU_Sel <= "000"; 
					CCR_Load <= '0';
					Bus1_Sel <= "00"; 
					Bus2_Sel <="01";
					iwrite <= '0';	
				elsif (IR = BEQ and CCR_Result(2) = '1') then 
					IR_Load <= '0';
					MAR_Load <= '0'; 
					PC_Load <= '0'; 
					PC_Inc <= '1'; 
					A_Load <= '0';
					B_Load <= '0'; 
					ALU_Sel <= "000"; 
					CCR_Load <= '0';
					Bus1_Sel <= "00"; 
					Bus2_Sel <="01";
					iwrite <= '0';	
				end if; 
				
			when S_LDA_IMM_5 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '1'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="01";
				iwrite <= '0';
			when S_LDA_IMM_6 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '1';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';
				
			when S_LDA_DIR_5 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '1'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="01";
				iwrite <= '0';
			when S_LDA_DIR_6 => 
				IR_Load <= '0';
				MAR_Load <= '1'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';
			when S_LDA_DIR_7 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';
			when S_LDA_DIR_8 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '1';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';
		
			when S_STA_DIR_5 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '1'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="01";
				iwrite <= '0';
			when S_STA_DIR_6 => 
				IR_Load <= '0';
				MAR_Load <= '1'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';
			when S_STA_DIR_7 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "01"; 
				Bus2_Sel <="10";
				iwrite <= '1';
				
			when S_LDB_IMM_5 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '1'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="01";
				iwrite <= '0';
			when S_LDB_IMM_6 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '1'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';
				
			when S_LDB_DIR_5 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '1'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="01";
				iwrite <= '0';
			when S_LDB_DIR_6 => 
				IR_Load <= '0';
				MAR_Load <= '1'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';
			when S_LDB_DIR_7 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';
			when S_LDB_DIR_8 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '1'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';
		
			when S_STB_DIR_5 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '1'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="01";
				iwrite <= '0';
			when S_STB_DIR_6 => 
				IR_Load <= '0';
				MAR_Load <= '1'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';
			when S_STB_DIR_7 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "01"; 
				Bus2_Sel <="10";
				iwrite <= '1';
				
			when S_BRA_5 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="01";
				iwrite <= '0';
			when S_BRA_6 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '1'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';	
				
			when S_BEQ_5 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="01";
				iwrite <= '0';
			when S_BEQ_6 => 
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '1'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="10";
				iwrite <= '0';	
			
			when others =>
				IR_Load <= '0';
				MAR_Load <= '0'; 
				PC_Load <= '0'; 
				PC_Inc <= '0'; 
				A_Load <= '0';
				B_Load <= '0'; 
				ALU_Sel <= "000"; 
				CCR_Load <= '0';
				Bus1_Sel <= "00"; 
				Bus2_Sel <="00";
				iwrite <= '0';	
		end case; 
	end process; 	
end arch_ControlUnit;