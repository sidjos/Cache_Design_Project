library IEEE;
use IEEE.std_logic_1164.all; -- std_logic

entity lru_counter_s is
  port (
    Update    : in std_logic;
    Rd        : in std_logic;
    Wr        : in std_logic;
    Reset     : in std_logic;
    Counter   : out std_logic_vector(31 downto 0)
    );
end lru_counter_s;

architecture lru_counter_str of lru_counter_s is  
  signal RSH_ip_s, RSH_op_s : std_logic_vector (31 downto 0); 
  signal wr_or_rd : std_logic;
begin 
-- Start 32 Bits D Flip Flop
  dff0_map :  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(0), enable=>'1',q=>RSH_ip_s(0));
  dff1_map :  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(1), enable=>'1',q=>RSH_ip_s(1));
  dff2_map :  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(2), enable=>'1',q=>RSH_ip_s(2));
  dff3_map :  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(3), enable=>'1',q=>RSH_ip_s(3));
  dff4_map :  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(4), enable=>'1',q=>RSH_ip_s(4));
  dff5_map :  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(5), enable=>'1',q=>RSH_ip_s(5));
  dff6_map :  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(6), enable=>'1',q=>RSH_ip_s(6));
  dff7_map :  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(7), enable=>'1',q=>RSH_ip_s(7));

  dff8_map :  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(8), enable=>'1',q=>RSH_ip_s(8));
  dff9_map :  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(9), enable=>'1',q=>RSH_ip_s(9));
  dff10_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(10), enable=>'1',q=>RSH_ip_s(10));
  dff11_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(11), enable=>'1',q=>RSH_ip_s(11));
  dff12_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(12), enable=>'1',q=>RSH_ip_s(12));
  dff13_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(13), enable=>'1',q=>RSH_ip_s(13));
  dff14_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(14), enable=>'1',q=>RSH_ip_s(14));
  dff15_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(15), enable=>'1',q=>RSH_ip_s(15));

  dff16_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(16), enable=>'1',q=>RSH_ip_s(16));
  dff17_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(17), enable=>'1',q=>RSH_ip_s(17));
  dff18_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(18), enable=>'1',q=>RSH_ip_s(18));
  dff19_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(19), enable=>'1',q=>RSH_ip_s(19));
  dff20_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(20), enable=>'1',q=>RSH_ip_s(20));
  dff21_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(21), enable=>'1',q=>RSH_ip_s(21));
  dff22_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'1', d=>RSH_op_s(22), enable=>'1',q=>RSH_ip_s(22));
  dff23_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(23), enable=>'1',q=>RSH_ip_s(23));

  dff24_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(24), enable=>'1',q=>RSH_ip_s(24));
  dff25_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(25), enable=>'1',q=>RSH_ip_s(25));
  dff26_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(26), enable=>'1',q=>RSH_ip_s(26));
  dff27_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(27), enable=>'1',q=>RSH_ip_s(27));
  dff28_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(28), enable=>'1',q=>RSH_ip_s(28));
  dff29_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(29), enable=>'1',q=>RSH_ip_s(29));
  dff30_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(30), enable=>'1',q=>RSH_ip_s(30));
  dff31_map:  entity work.dffr_a  port map (clk=>Update, arst=>Reset, aload=>'0', adata=>'0', d=>RSH_op_s(31), enable=>'1',q=>RSH_ip_s(31));
-- End 32 Bits D Flip Flop

  Or_g : entity work.or_gate
    port map(Wr, Rd, wr_or_rd);

  RSH_g : entity work.rightshifter_32to32_s
    port map(B"00001", wr_or_rd, RSH_ip_s, RSH_op_s);

  Counter <= RSH_ip_s;
end architecture lru_counter_str;
