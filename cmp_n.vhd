library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmp_n is
  generic (
    n : integer
  );
  port (
    a      : in std_logic_vector(n-1 downto 0);
    b      : in std_logic_vector(n-1 downto 0);

    a_eq_b : out std_logic;
    a_gt_b : out std_logic;
    a_lt_b : out std_logic;

    signed_a_gt_b : out std_logic;
    signed_a_lt_b : out std_logic
  );
end entity cmp_n;

architecture behavioral of cmp_n is
begin
  a_eq_b <= '1' when unsigned(a) = unsigned(b) else '0';
  a_gt_b <= '1' when unsigned(a) > unsigned(b) else '0';
  a_lt_b <= '1' when unsigned(a) < unsigned(b) else '0';

  signed_a_gt_b <= '1' when signed(a) > signed(b) else '0';
  signed_a_lt_b <= '1' when signed(a) < signed(b) else '0';
end architecture behavioral;
