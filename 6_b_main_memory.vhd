library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity main_memory is
	generic ( memfile_s: string);
	port (
		clk:     	in std_logic; 
		reset:		in std_logic; 
		address:	in std_logic_vector(31 downto 0); 
		L2_Miss: 	in std_logic;
		write: 		in std_logic;
		data_in: 	in std_logic_vector (31 downto 0);
		data_in_buffer: in std_logic_vector ( 63 downto 0);
		data_valid: 	out std_logic;
		data_out: 	out std_logic_vector(2047 downto 0)
	);
end main_memory;

architecture structural of main_memory is

signal mux0,mux1,mux2,mux3,mux4,shifter,fulladder1: std_logic_vector(2047 downto 0);
signal mux6: std_logic_vector(9 downto 0);
signal syncram0,counter,pc0: std_logic_vector(31 downto 0);
signal not0: std_logic;


begin
    
   --32 bits counter (positive edge)
   fulladder0_map:  fulladder_32 port map (cin=>'0', x=>pc0, y=>B"00000000000000000000000000000001", z=>counter);

   generate_memory0: for i in 0 to 31 generate
   map_memory_reg0: dffr_a port map (clk=>clk, arst=>reset, aload=>'0', adata=>'0', d=>fulladder0(i), enable=>'1',q=>pc0(i));
   end generate_memory0;
   
   	
   --main memory 
   mux6_map: 	mux_n generic map (n=>10) port map (sel=>write, src0=>B"0000000000", src1=>addr(9 downto 0), z=>mux6);
   syncram_map:	syncram (mem_file => memfile_s)
   		port map (clk=>, cs=>'1', oe=>'1', we=>write, addr(31 downto 10)=>addr(31 downto 10), addr(9 downto 0)=>mux6, din=>data_in, dout=>syncram0);
   
   --shifter
   --1024-bit
   mux0_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(5), src0=>syncram0, src1(2047 downto 1024)=>x(1023 downto 0), src1(1023 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux0);
   --512-bit
   mux1_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(4), src0=>mux0, src1(2047 downto 512)=>mux0(1535 downto 0),src1(511 downto 0)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux1);
   --256-bit
   mux2_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(3), src0=>mux1, src1(2047 downto 256)=>mux1(1791 downto 0),src1(255 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux2);
   --128-bit
   mux3_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(2), src0=>mux2, src1(2047 downto 128)=>mux2(1919 downto 0),src1(127 downto 0)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux3);
   --64-bit
   mux4_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(1), src0=>mux3, src1(2047 downto 64)=>mux3(1984 downto 0),src1(63 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000", z=>mux4);
   --32-bit
   mux5_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(0), src0=>mux4, src1(2047 downto 32)=>mux4(2015 downto 0),src1(31 downto 0)=>B"00000000000000000000000000000000", z=>shifter);
   
   --Temporary 256 bytes Registers (negative edge)
   
   fulladder1_map:  fulladder_n generic map (n=>2048) port map (cin=>'0', x=>data_out, y=>shifter, z=>fulladder1);
   not0_map:	not_gate port map (x=>clk,z=>not_clk);
   
   generate_memory1: for i in 0 to 2047 generate
   map_memory_reg1: dffr_a port map (clk=>not_clk, arst=>rst,aload=>'0', adata=>'0', d=>fulladder1(i), enable=>'1',q=>data_out(i));
   end generate_memory1;
   
   --Valid 
   and0_map: and_gate port map (x=>counter(0), y=>counter(1), z=>and0);
   and1_map: and_gate port map (x=>and0, y=>counter(2), z=>and1);
   and2_map: and_gate port map (x=>and1, y=>counter(3), z=>and2);
   and3_map: and_gate port map (x=>and2, y=>counter(4), z=>and3);
   and4_map: and_gate port map (x=>and3, y=>counter(5), z=>and4);
   
   
end architecture structural;

