library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.mux_n;

entity mux is
  port (
	sel	  : in	std_logic;
	src0  :	in	std_logic;
	src1  :	in	std_logic;
	z	  : out std_logic
  );
end mux;

architecture structural of mux is
begin
  mux_map: mux_n
	generic map (n => 1)
	port map (
	  sel => sel,
	  src0(0) => src0,
	  src1(0) => src1,
	  z(0) => z);
end structural;

