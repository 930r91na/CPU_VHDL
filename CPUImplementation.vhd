library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPUImplementation is
    port (
	  -- inputs
	  clk, reset: in std_logic;
	  
	  port_in_01: in std_logic_vector(7 downto 0);
	  port_in_02: in std_logic_vector(7 downto 0);
	  port_in_03: in std_logic_vector(7 downto 0);
	  port_in_04: in std_logic_vector(7 downto 0);
	  port_in_05: in std_logic_vector(7 downto 0);
	  port_in_06: in std_logic_vector(7 downto 0);
	  port_in_07: in std_logic_vector(7 downto 0);
	  port_in_08: in std_logic_vector(7 downto 0);
	  port_in_09: in std_logic_vector(7 downto 0);
	  port_in_10: in std_logic_vector(7 downto 0);
	  port_in_11: in std_logic_vector(7 downto 0);
	  port_in_12: in std_logic_vector(7 downto 0);
	  port_in_13: in std_logic_vector(7 downto 0);
	  port_in_14: in std_logic_vector(7 downto 0);
	  port_in_15: in std_logic_vector(7 downto 0);
	  port_in_16: in std_logic_vector(7 downto 0);
	  
	  -- outputs
	  port_out_01: out std_logic_vector(7 downto 0);
	  port_out_02: out std_logic_vector(7 downto 0);
	  port_out_03: out std_logic_vector(7 downto 0);
	  port_out_04: out std_logic_vector(7 downto 0);
	  port_out_05: out std_logic_vector(7 downto 0);
	  port_out_06: out std_logic_vector(7 downto 0);
	  port_out_07: out std_logic_vector(7 downto 0);
	  port_out_08: out std_logic_vector(7 downto 0);
	  port_out_09: out std_logic_vector(7 downto 0);
	  port_out_10: out std_logic_vector(7 downto 0);
	  port_out_11: out std_logic_vector(7 downto 0);
	  port_out_12: out std_logic_vector(7 downto 0);
	  port_out_13: out std_logic_vector(7 downto 0);
	  port_out_14: out std_logic_vector(7 downto 0);
	  port_out_15: out std_logic_vector(7 downto 0);
	  port_out_16: out std_logic_vector(7 downto 0)	
	  
    );
end CPUImplementation;

architecture ARCH_CPU_Implementation of CPUImplementation is

signal address : std_logic_vector(7 downto 0);
signal data_in : std_logic_vector(7 downto 0);
signal data_out : std_logic_vector(7 downto 0);
signal iwrite : std_logic;


begin
    -- Instance of the CPU
    CPU_Instance: entity work.CPU
    port map (
        clk => clk,
        reset => reset,
        from_memory => data_out, 
        address => address,      
        to_memory => data_in,     
        iwrite => iwrite          
    );
	Memory_Instance: entity work.Memory
        port map (
            clk => clk,
            reset => reset,
            address => address,
            data_in => data_in,
            iwrite => iwrite,
            
            port_in_01 => port_in_01,
            port_in_02 => port_in_02,
            port_in_03 => port_in_03,
            port_in_04 => port_in_04,
            port_in_05 => port_in_05,
            port_in_06 => port_in_06,
            port_in_07 => port_in_07,
            port_in_08 => port_in_08,
            port_in_09 => port_in_09,
            port_in_10 => port_in_10,
            port_in_11 => port_in_11,
            port_in_12 => port_in_12,
            port_in_13 => port_in_13,
            port_in_14 => port_in_14,
            port_in_15 => port_in_15,
            port_in_16 => port_in_16,
            
            data_out => data_out,
            
            port_out_01 => port_out_01,
            port_out_02 => port_out_02,
            port_out_03 => port_out_03,
            port_out_04 => port_out_04,
            port_out_05 => port_out_05,
            port_out_06 => port_out_06,
            port_out_07 => port_out_07,
            port_out_08 => port_out_08,
            port_out_09 => port_out_09,
            port_out_10 => port_out_10,
            port_out_11 => port_out_11,
            port_out_12 => port_out_12,
            port_out_13 => port_out_13,
            port_out_14 => port_out_14,
            port_out_15 => port_out_15,
            port_out_16 => port_out_16
        );


end ARCH_CPU_Implementation;
