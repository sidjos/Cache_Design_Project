library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity main_memory is
	port (
		addr	in std_logic_vector(31 downto 0); 
		x: 	in std_logic_vector(511 downto 0); -- 512-bit input data
		y: 	in std_logic_vector(5 downto 0);  -- Position to be shifted (activate with 1)
		z: 	out std_logic_vector(511 downto 0); -- Output
		data_valid: out std_logic
	);
end main_memory;

architecture structural of main_memory is

signal mux0: std_logic_vector(2047 downto 0);
signal mux1: std_logic_vector(2047 downto 0);
signal mux2: std_logic_vector(2047 downto 0);
signal mux3: std_logic_vector(2047 downto 0);
signal mux4: std_logic_vector(2047 downto 0);
signal mux5: std_logic_vector(2047 downto 0);
signal syncram0: std_logic_vector(31 downto 0);


begin
    
   --shifter
   
   --1024-bit
   mux0_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(5), src0=>x, src1(2047 downto 1024)=>x(1024 downto 0), src1(1023 downto 0)=>B"", z=>mux0);
   --512-bit
   mux1_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(4), src0=>mux0, src1(2047 downto 512)=>mux0(1536 downto 0),src1(511 downto 0)=>B"", z=>mux1);
   --256-bit
   mux2_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(3), src0=>mux1, src1(2047 downto 256)=>mux1(1792 downto 0),src1(255 downto 0)=>B"", z=>mux2);
   --128-bit
   mux3_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(2), src0=>mux2, src1(2047 downto 128)=>mux2(1920 downto 0),src1(127 downto 0)=>B"", z=>mux3);
   --64-bit
   mux4_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(1), src0=>mux3, src1(2047 downto 64)=>mux3(1985 downto 0),src1(63 downto 0)=>B"", z=>mux4);
   --32-bit
   mux5_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(0), src0=>mux4, src1(2047 downto 32)=>mux4(2016 downto 0),src1(31 downto 0)=>B"", z=>mux5);
   
   
   --main memory 
   syncram_map:	syncram generic (mem_file : string);
   		port map (clk=>, cs=>1, oe=>1, we=>0, 
   			  addr(31 downto 10)=>addr(31 downto 10), addr(9 downto 0)=>B"0000000000", 
   			  din=>B"00000000000000000000000000000000", dout=>syncram0);
   	
   mux3_map:	mux_n generic map (n=>512)	 port map (sel=>y(2), src0=>mux2, src1=>, z=>);
	
end architecture structural;

