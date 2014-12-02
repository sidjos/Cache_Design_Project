library IEEE;
use IEEE.std_logic_1164.all; -- std_logic

entity com_4toOffset_s is 
  port (
    xb0_i    : in std_logic_vector(31 downto 0);
    xa1_i    : in std_logic_vector(31 downto 0);
    xb2_i    : in std_logic_vector(31 downto 0);
    xa3_i    : in std_logic_vector(31 downto 0);
    Offset     : out std_logic_vector(1 downto 0)
    );
end com_4toOffset_s;

architecture com_4toOffset_str of com_4toOffset_s is
  signal x0_offset : std_logic_vector(1 downto 0) := B"00";
  signal x1_offset : std_logic_vector(1 downto 0) := B"01";
  signal x2_offset : std_logic_vector(1 downto 0) := B"10";
  signal x3_offset : std_logic_vector(1 downto 0) := B"11";
  signal com00_e_s, com00_l_s, com01_e_s, com01_l_s, com10_e_s, com10_l_s : std_logic;
  signal el_com00_s, el_com01_s, el_com10_s : std_logic;
  signal mux0_b_s, mux1_a_s : std_logic_vector (31 downto 0);
  signal mux00_off_s, mux01_off_s : std_logic_vector (1 downto 0);
begin 
  com00_x0x1 : entity work.cmp_n
    generic map (n => 32)
    port map (
      a => xa1_i,
      b => xb0_i,
      a_eq_b => com00_e_s,
      a_lt_b => com00_l_s
      );

  or_com00 : entity work.or_gate
    port map(com00_e_s, com00_l_s, el_com00_s);

  com01_x2x3 : entity work.cmp_n
    generic map (n => 32)
    port map (
      a => xa3_i,
      b => xb2_i,
      a_eq_b => com01_e_s,
      a_lt_b => com01_l_s
      );

  or_com01 : entity work.or_gate
    port map(com01_e_s, com01_l_s, el_com01_s);

  mux0_x0x1 : entity work.mux_n
    generic map (n => 32)
    port map (
      sel => el_com00_s,
      src0 => xb0_i,
      src1 => xa1_i,
      z => mux0_b_s
      );

  mux1_x2x3 : entity work.mux_n
    generic map (n => 32)
    port map (
      sel => el_com01_s,
      src0 => xb2_i,
      src1 => xa3_i,
      z => mux1_a_s
      );

  com10_l : entity work.cmp_n
    generic map (n => 32)
    port map (
      a => mux1_a_s,
      b => mux0_b_s,
      a_eq_b => com10_e_s,
      a_lt_b => com10_l_s
      );

  or_com10 : entity work.or_gate
    port map(com10_e_s, com10_l_s, el_com10_s);

-- mux offset selection
  mux00_off0off1 : entity work.mux_n
    generic map (n => 2)
    port map (
      sel => el_com00_s,
      src0 => x0_offset,
      src1 => x1_offset,
      z => mux00_off_s
      );

  mux01_off2off3 : entity work.mux_n
    generic map (n => 2)
    port map (
      sel => el_com01_s,
      src0 => x2_offset,
      src1 => x3_offset,
      z => mux01_off_s
      );

  mux10_off : entity work.mux_n
    generic map (n => 2)
    port map (
      sel => el_com10_s,
      src0 => mux00_off_s,
      src1 => mux01_off_s,
      z => Offset
      );
end architecture com_4toOffset_str;
