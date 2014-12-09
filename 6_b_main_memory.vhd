library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity main_memory is
	generic ( mem_file: string);
	port (
		clk:     	in std_logic; 
		reset:		in std_logic; 
		address:	in std_logic_vector(31 downto 0); 
		L2_Miss: 	in std_logic; --reading
		main_write: 	in std_logic; --writing
		data_in: 	in std_logic_vector (511 downto 0);
		data_valid_read: 	out std_logic;
		data_valid_write: 	out std_logic;
		data_out_with_tag: 	out std_logic_vector(2069 downto 0)
	);
end main_memory;

architecture structural of main_memory is

signal mux0,mux1,mux2,mux3,mux4,shifter,mux00,mux11,mux22,mux33,mux44,clean_32bit,before_reg_out, data_out_sig, not_clean_32bit, data_out_sig_clean: std_logic_vector(2047 downto 0);
signal mux0_wr,mux1_wr,mux2_wr,mux3_wr,shifter_wr: std_logic_vector(511 downto 0);
signal mux6: std_logic_vector(7 downto 0);
signal syncram0,counter,counter_reg,counter_minus_one,not0_wr: std_logic_vector(31 downto 0);
signal not1,not11,and0,counter_minus_one_to_be_64, counter_reg_to_be_64, clk_with_stop_write,clk_with_stop_and_trigger_write,
not_clk_with_stop_and_trigger_write,clk_with_stop_read,clk_with_stop_and_trigger_read,
not_clk_with_stop_and_trigger_read,counter_to_be_all_zero,and0_wr,and1_wr,and2_wr,
clk_with_stop_and_trigger, not_clk_with_stop_and_trigger: std_logic;


begin
        
 --Writing
 
   not_wr_map: not_gate_n generic map (n=>32)  port map (x=>counter_minus_one, z=>not0_wr);
 
 mux0_wr_map:	mux_n generic map (n=>512)	 port map (sel=>not0_wr(3), src0=>data_in, src1(511 downto 256)=>data_in(255 downto 0), src1(255 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux0_wr);
	mux1_wr_map:	mux_n generic map (n=>512)	 port map (sel=>not0_wr(2), src0=>mux0_wr, src1(511 downto 128)=>mux0_wr(383 downto 0),src1(127 downto 0)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux1_wr);
	mux2_wr_map:	mux_n generic map (n=>512)	 port map (sel=>not0_wr(1), src0=>mux1_wr, src1(511 downto 64)=>mux1_wr(447 downto 0),src1(63 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000", z=>mux2_wr);
   mux3_wr_map:	mux_n generic map (n=>512)	 port map (sel=>not0_wr(0), src0=>mux2_wr, src1(511 downto 32)=>mux2_wr(479 downto 0),src1(31 downto 0)=>B"00000000000000000000000000000000", z=>shifter_wr);



 
   
   
   and0_wr_map: 	and_gate port map (x=>not0_wr(0),y=>not0_wr(1),z=>and0_wr);
   and1_wr_map: 		and_gate port map (x=>not0_wr(2),y=>not0_wr(3),z=>and1_wr);
   and2_wr_map:		 and_gate port map (x=>and0_wr,y=>and1_wr,z=>and2_wr);
   and3_wr_map: 	and_gate port map (x=>and2_wr,y=>not0_wr(4),z=>counter_to_be_all_zero);
   data_valid_write <= counter_to_be_all_zero;
   
   or00_map:  		or_gate port map (x=>clk, y=>counter_to_be_all_zero, z=>clk_with_stop_write);
   and11_map:  		and_gate port map (x=>clk_with_stop_write, y=>main_write, z=>clk_with_stop_and_trigger_write);
   not00_map:		not_gate port map (x=>clk_with_stop_and_trigger_write,z=>not_clk_with_stop_and_trigger_write);
   
   mux_clk_map: mux port map (sel=>main_write, src0=>clk_with_stop_and_trigger_read, src1=>clk_with_stop_and_trigger_write, z=>clk_with_stop_and_trigger);
   mux_not_clk_map: mux port map (sel=>main_write, src0=>not_clk_with_stop_and_trigger_read, src1=>not_clk_with_stop_and_trigger_write, z=>not_clk_with_stop_and_trigger);
 
 
 
 
 
 
 --Reading  
 
 --valid 
 --not11_map: not_gate port map (x=>counter_minus_one(1), z=>not11);
 --and22_map: and_gate port map (x=>counter_minus_one(6), y=>not11, z=>counter_minus_one_to_be_64);
   data_valid_read <= counter_minus_one_to_be_64;
   
   not1_map: not_gate port map (x=>counter_minus_one(1), z=>not1);
   and2_map: and_gate port map (x=>counter_minus_one(6), y=>not1, z=>counter_minus_one_to_be_64);
   or0_map:  or_gate port map (x=>clk, y=>counter_minus_one_to_be_64, z=>clk_with_stop_read);
   and1_map:  and_gate port map (x=>clk_with_stop_read, y=>L2_Miss, z=>clk_with_stop_and_trigger_read);
   not0_map:	not_gate port map (x=>clk_with_stop_and_trigger_read,z=>not_clk_with_stop_and_trigger_read);


   --main memory 
  
   syncram_map:	syncram generic map (mem_file => mem_file)
				port map (clk=>clk_with_stop_and_trigger, cs=>'1', oe=>'1', we=>main_write, addr(31 downto 8)=>address(31 downto 8), addr(7 downto 0)=>B"00000000", din=>data_in(511 downto 480), dout=>syncram0);
  
   --32 bits counter (positive edge)
   fulladder0_map:  fulladder_32 port map (cin=>'0', x=>counter_reg, y=>B"00000000000000000000000000000001", z=>counter);
   generate_memory0: for i in 0 to 31 generate
   map_memory_reg0: dffr_a port map (clk=>clk_with_stop_and_trigger, arst=>reset, aload=>'0', adata=>'0', d=>counter(i), enable=>'1',q=>counter_reg(i));
   end generate generate_memory0;
	
    fulladder2_map:  fulladder_32 port map (cin=>'0', x=>counter_reg, y=>B"11111111111111111111111111111111", z=>counter_minus_one);

   --temporary 256 bytes Registers (negative edge)
   --1024-bit
   mux0_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(5), 
   							   src0(31 downto 0)=>syncram0,
   							   src0(2047 downto 32)=>B"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
   							   src1(1055 downto 1024)=>syncram0,
   							   src1(2047 downto 1056)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
   							   src1(511 downto 0)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
   							   src1(1023 downto 512)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
   							   z=>mux0);
   --512-bit
   mux1_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(4), src0=>mux0, src1(2047 downto 512)=>mux0(1535 downto 0),src1(511 downto 0)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux1);
   --256-bit
   mux2_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(3), src0=>mux1, src1(2047 downto 256)=>mux1(1791 downto 0),src1(255 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux2);
   --128-bit
   mux3_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(2), src0=>mux2, src1(2047 downto 128)=>mux2(1919 downto 0),src1(127 downto 0)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux3);
   --64-bit
   mux4_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(1), src0=>mux3, src1(2047 downto 64)=>mux3(1983 downto 0),src1(63 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000", z=>mux4);
   --32-bit
   mux5_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(0), src0=>mux4, src1(2047 downto 32)=>mux4(2015 downto 0),src1(31 downto 0)=>B"00000000000000000000000000000000", z=>shifter);
   
    --1024-bit
   mux00_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(5), 
   							   src0(31 downto 0)=>B"11111111111111111111111111111111",
   							   src0(2047 downto 32)=>B"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
   							   src1(1055 downto 1024)=>B"11111111111111111111111111111111",
   							   src1(2047 downto 1056)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
   							   src1(511 downto 0)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
   							   src1(1023 downto 512)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
   							   z=>mux00);
   --512-bit
   mux11_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(4), src0=>mux00, src1(2047 downto 512)=>mux00(1535 downto 0),src1(511 downto 0)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux11);
   --256-bit
   mux22_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(3), src0=>mux11, src1(2047 downto 256)=>mux11(1791 downto 0),src1(255 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux22);
   --128-bit
   mux33_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(2), src0=>mux22, src1(2047 downto 128)=>mux22(1919 downto 0),src1(127 downto 0)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux33);
   --64-bit
   mux44_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(1), src0=>mux33, src1(2047 downto 64)=>mux33(1983 downto 0),src1(63 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000", z=>mux44);
   --32-bit
   mux55_map:	mux_n generic map (n=>2048)	 port map (sel=>counter_minus_one(0), src0=>mux44, src1(2047 downto 32)=>mux44(2015 downto 0),src1(31 downto 0)=>B"00000000000000000000000000000000", z=>clean_32bit);
   
   not2_map:	not_gate_n generic map (n=>2048) port map (x=>clean_32bit,z=>not_clean_32bit);
   and3_map:    and_gate_n generic map (n=>2048) port map (x=>data_out_sig,y=>not_clean_32bit,z=>data_out_sig_clean);
   
   data_out_with_tag <= address(31 downto 10) & data_out_sig;
   
     
   fulladder1_map:  fulladder_n generic map (n=>2048) port map (cin=>'0', x=>data_out_sig_clean, y=>shifter, z=>before_reg_out);

   generate_memory1: for i in 0 to 2047 generate
   map_memory_reg1: dffr_a port map (clk=>not_clk_with_stop_and_trigger, arst=>reset, aload=>'0', adata=>'0', d=>before_reg_out(i), enable=>'1',q=>data_out_sig(i));
   end generate generate_memory1;
   
end architecture structural;

