library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity main_memory is
	generic ( memfile_s: string);
	port (
		rst	in std_logic; 
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
signal fulladder0: std_logic_vector(31 downto 0);
signal mux6: std_logic_vector(31 downto 0);
signal pc0: std_logic_vector(31 downto 0);
signal not0: std_logic;


begin
    
   	--counter
	fulladder_map:  fulladder_32 port map (cin=>'0', x=>pc0, y=>B"00000000000000000000000000000001", z=>mux6);
   
   	not0_map:	not_gate port map (x=>clk,z=>not_clk);
   
   	dff0_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(0), enable=>'1',q=>pc0(0));
	dff1_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(1), enable=>'1',q=>pc0(1));
	dff2_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(2), enable=>'1',q=>pc0(2));
	dff3_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(3), enable=>'1',q=>pc0(3));
	dff4_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(4), enable=>'1',q=>pc0(4));
	dff5_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'1', d=>mux6(5), enable=>'1',q=>pc0(5));
	dff6_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(6), enable=>'1',q=>pc0(6));
	dff7_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(7), enable=>'1',q=>pc0(7));

	dff8_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(8), enable=>'1',q=>pc0(8));
	dff9_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(9), enable=>'1',q=>pc0(9));
	dff10_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(10), enable=>'1',q=>pc0(10));
	dff11_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(11), enable=>'1',q=>pc0(11));
	dff12_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(12), enable=>'1',q=>pc0(12));
	dff13_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(13), enable=>'1',q=>pc0(13));
	dff14_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(14), enable=>'1',q=>pc0(14));
	dff15_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(15), enable=>'1',q=>pc0(15));

	dff16_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(16), enable=>'1',q=>pc0(16));
	dff17_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(17), enable=>'1',q=>pc0(17));
	dff18_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(18), enable=>'1',q=>pc0(18));
	dff19_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(19), enable=>'1',q=>pc0(19));
	dff20_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(20), enable=>'1',q=>pc0(20));
	dff21_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(21), enable=>'1',q=>pc0(21));
	dff22_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'1', d=>mux6(22), enable=>'1',q=>pc0(22));
	dff23_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(23), enable=>'1',q=>pc0(23));

	dff24_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(24), enable=>'1',q=>pc0(24));
	dff25_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(25), enable=>'1',q=>pc0(25));
	dff26_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(26), enable=>'1',q=>pc0(26));
	dff27_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(27), enable=>'1',q=>pc0(27));
	dff28_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(28), enable=>'1',q=>pc0(28));
	dff29_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(29), enable=>'1',q=>pc0(29));
	dff30_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(30), enable=>'1',q=>pc0(30));
	dff31_map:	dffr_a	port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>mux6(31), enable=>'1',q=>pc0(31));
  
  
  
  
   --main memory 
   syncram_map:	syncram (mem_file => memfile_s)
   		port map (clk=>, cs=>'1', oe=>'1', we=>'0', 
   			  addr(31 downto 10)=>addr(31 downto 10), addr(9 downto 0)=>B"0000000000", 
   			  din=>B"00000000000000000000000000000000", dout=>syncram0);
   
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
   mux5_map:	mux_n generic map (n=>2048)	 port map (sel=>counter(0), src0=>mux4, src1(2047 downto 32)=>mux4(2015 downto 0),src1(31 downto 0)=>B"00000000000000000000000000000000", z=>mux5);
   
   --sid
   generate_memory: for i in 0 to 31 generate
		map_memory_reg: dffr_a port map (clk=>not_clk, arst=>'0',aload=>rst, adata=>'0', d=>input(i), enable=>'1',q=>out(i));
end generate map_memory_reg;
   
   	
   mux3_map:	mux_n generic map (n=>512)	 port map (sel=>y(2), src0=>mux2, src1=>, z=>);
	
end architecture structural;

