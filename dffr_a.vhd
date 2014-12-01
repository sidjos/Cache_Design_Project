library ieee;
use ieee.std_logic_1164.all;

entity dffr_a is
  port (
	clk	   : in  std_logic;
    arst   : in  std_logic;
    aload  : in  std_logic;
    adata  : in  std_logic;
	d	   : in  std_logic;
    enable : in  std_logic;
	q	   : out std_logic
  );
end dffr_a;

architecture behavioral of dffr_a is
begin
  proc : process (clk, arst, aload)
  begin
    if arst = '1' then
      q <= '0';
    elsif aload = '1' then
      q <= adata;
    elsif rising_edge(clk) then
      if enable = '1' then
	    q <= d;
      end if;
	end if;
  end process;
end behavioral;
