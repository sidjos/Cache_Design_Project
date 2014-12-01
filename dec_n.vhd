library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec_n is
  generic (
    n	: integer
  );
  port (
    src	: in std_logic_vector(n-1 downto 0);
    z	: out std_logic_vector((2**n)-1 downto 0)
  );
end dec_n;

architecture behavioral of dec_n is
begin
  gen_z : for i in 0 to (2**n) - 1 generate
    z(i) <= '1' when src = std_logic_vector(to_unsigned(i, n)) else '0';
  end generate gen_z;
end behavioral;
