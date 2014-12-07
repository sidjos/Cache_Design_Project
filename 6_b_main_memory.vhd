library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity main_memory is
	--generic ( mem_file: string);
	port (
		clk:     		in std_logic; 
		reset:		in std_logic; 
		address:		in std_logic_vector(31 downto 0); 
		L2_Miss: 	in std_logic;
		write: 		in std_logic;
		data_in: 	in std_logic_vector (31 downto 0);
		data_valid: 	out std_logic;
		data_out: 	out std_logic_vector(2047 downto 0)
	);
end main_memory;

architecture structural of main_memory is

signal mux0,mux1,mux2,mux3,mux4,shifter,fulladder1: std_logic_vector(2047 downto 0);
signal mux6: std_logic_vector(9 downto 0);
signal syncram0,counter,pc0: std_logic_vector(31 downto 0);
signal not0,clk_new1,clk_new2,not_clk_new2,not_L2_Miss: std_logic;


begin
    
   --reset
   not1_map: not_gate port map (x=>L2_Miss, z=>not_L2_Miss);
   or1_map:  or_gate port map (x=>reset, y=>not_L2_Miss, z=>clk_new1);
    
    
   --main memory 
   mux6_map: 	mux_n generic map (n=>10) port map (sel=>write, src0=>B"0000000000", src1=>address(9 downto 0), z=>mux6);

 --  syncram_map:	generic map (mem_file => "sort_corrected_branch.dat");
				--port map (clk=>clk_new2, cs=>'1', oe=>'1', we=>write, addr(31 downto 10)=>addr(31 downto 10), addr(9 downto 0)=>mux6, din=>data_in, dout=>syncram0);
  
   --32 bits counter (positive edge)
   fulladder0_map:  fulladder_32 port map (cin=>'0', x=>pc0, y=>B"00000000000000000000000000000001", z=>counter);
   generate_memory0: for i in 0 to 31 generate
   map_memory_reg0: dffr_a port map (clk=>clk_new2, arst=>reset, aload=>'0', adata=>'0', d=>counter(i), enable=>'1',q=>pc0(i));
   end generate_memory0;
   
   --shifter
   --1024-bit
   mux0_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(5), src0=>syncram0, src1(2047 downto 1024)=>x(1023 downto 0), src1(511 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux0);
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
   
   --temporary 256 bytes Registers (negative edge)
   
   fulladder1_map:  fulladder_n generic map (n=>2048) port map (cin=>'0', x=>data_out, y=>shifter, z=>fulladder1);
   not0_map:	not_gate port map (x=>clk_new2,z=>not_clk_new2);
   generate_memory1: for i in 0 to 2047 generate
   map_memory_reg1: dffr_a port map (clk=>not_clk, arst=>rst,aload=>'0', adata=>'0', d=>fulladder1(i), enable=>'1',q=>data_out(i));
   end generate_memory1;
   
   --valid 
   and0_map: and_gate port map (x=>counter(6), y=>counter(0), z=>data_valid);
   or0_map:  or_gate port map (x=>clk, y=>data_valid, z=>clk_new1);
   and1_map:  or_gate port map (x=>clk_new1, y=>L2_Miss, z=>clk_new2);
   
  
   
end architecture structural;

