library ieee;
use ieee.std_logic_1164.all;

entity dffr is
  port (
	clk	: in  std_logic;
	d	: in  std_logic;
	q	: out std_logic
  );
end dffr;

architecture behavioral of dffr is
begin
  proc : process (clk)
  begin
	if rising_edge(clk) then
	  q <= d;
	end if;
  end process;
end behavioral;
