library ieee;
use ieee.std_logic_1164.all;

entity fulladder_32 is
  port (
    cin   : in std_logic;
    x     : in std_logic_vector(31 downto 0);
    y     : in std_logic_vector(31 downto 0);
    cout  : out std_logic;
    z     : out std_logic_vector(31 downto 0)
  );
end fulladder_32;

architecture behavioral of fulladder_32 is
component fulladder_n is
  generic (
    n : integer
  );
  port (
    cin   : in std_logic;
    x     : in std_logic_vector(n-1 downto 0);
    y     : in std_logic_vector(n-1 downto 0);
    cout  : out std_logic;
    z     : out std_logic_vector(n-1 downto 0)
  );
end component fulladder_n;
begin
  adder_map : fulladder_n
    generic map (n => 32)
    port map (
      cin => cin,
      x => x,
      y => y,
      cout => cout,
      z => z
    );
end behavioral;
