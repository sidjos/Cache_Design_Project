library IEEE;
use IEEE.std_logic_1164.all; -- std_logic

entity Counter_s is
  port (
    FA_1or0   : in std_logic;
    Clk_ip    : in std_logic;
    Reset     : in std_logic;
    FA_ip_op   : out std_logic_vector(31 downto 0)
    );
end Counter_s;

architecture Counter_str of Counter_s is  
  signal FA_ip_1or0, FA_ip, FA_op : std_logic_vector (31 downto 0); 
begin 
-- Start 32 Bits D Flip Flop
  dff0_map :  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(0), enable=>'1',q=>FA_ip(0));
  dff1_map :  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(1), enable=>'1',q=>FA_ip(1));
  dff2_map :  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(2), enable=>'1',q=>FA_ip(2));
  dff3_map :  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(3), enable=>'1',q=>FA_ip(3));
  dff4_map :  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(4), enable=>'1',q=>FA_ip(4));
  dff5_map :  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(5), enable=>'1',q=>FA_ip(5));
  dff6_map :  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(6), enable=>'1',q=>FA_ip(6));
  dff7_map :  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(7), enable=>'1',q=>FA_ip(7));

  dff8_map :  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(8), enable=>'1',q=>FA_ip(8));
  dff9_map :  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(9), enable=>'1',q=>FA_ip(9));
  dff10_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(10), enable=>'1',q=>FA_ip(10));
  dff11_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(11), enable=>'1',q=>FA_ip(11));
  dff12_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(12), enable=>'1',q=>FA_ip(12));
  dff13_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(13), enable=>'1',q=>FA_ip(13));
  dff14_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(14), enable=>'1',q=>FA_ip(14));
  dff15_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(15), enable=>'1',q=>FA_ip(15));

  dff16_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(16), enable=>'1',q=>FA_ip(16));
  dff17_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(17), enable=>'1',q=>FA_ip(17));
  dff18_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(18), enable=>'1',q=>FA_ip(18));
  dff19_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(19), enable=>'1',q=>FA_ip(19));
  dff20_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(20), enable=>'1',q=>FA_ip(20));
  dff21_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(21), enable=>'1',q=>FA_ip(21));
  dff22_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'1', d=>FA_op(22), enable=>'1',q=>FA_ip(22));
  dff23_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(23), enable=>'1',q=>FA_ip(23));

  dff24_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(24), enable=>'1',q=>FA_ip(24));
  dff25_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(25), enable=>'1',q=>FA_ip(25));
  dff26_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(26), enable=>'1',q=>FA_ip(26));
  dff27_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(27), enable=>'1',q=>FA_ip(27));
  dff28_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(28), enable=>'1',q=>FA_ip(28));
  dff29_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(29), enable=>'1',q=>FA_ip(29));
  dff30_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(30), enable=>'1',q=>FA_ip(30));
  dff31_map:  entity work.dffr_a  port map (clk=>Clk_ip, arst=>Reset,aload=>'0', adata=>'0', d=>FA_op(31), enable=>'1',q=>FA_ip(31));
-- End 32 Bits D Flip Flop

  FA_ip_op <= FA_ip;

-- Start Multiplexer to select either 1 or 0 to be the input of the adder
  mux_1or0 : entity work.mux_n
    generic map(n => 32)
    port map(FA_1or0, X"00_00_00_00", X"00_00_00_01", FA_ip_1or0);
-- End Multiplexer to select either 1 or 0 to be the input of the adder

-- Start 32 Bits Adder
  Add_Counter : entity work.fulladder_n
    generic map(n => 32)
    port map(
      cin => '0',
      x => FA_ip_1or0,
      y => FA_ip,
      z => FA_op
      );
-- End 32 Bits Adder
end Counter_str;

