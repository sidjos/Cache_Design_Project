library ieee;
use ieee.std_logic_1164.all;

entity dff is
  port (
	clk	: in  std_logic;
	d	: in  std_logic;
	q	: out std_logic
  );
end dff;

architecture behavioral of dff is
begin
  proc : process (clk)
  begin
	if falling_edge(clk) then
	  q <= d;
	end if;
  end process;
end behavioral;
