library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use ieee.numeric_std.all;

-- With reference to http://www.dte.us.es/ing_inf/dise_comp/VHDLsimCMSG.pdf
-- Sparse SRAM

entity csram is
  generic (
    INDEX_WIDTH : integer;
    BIT_WIDTH : integer
  );
  port (
	cs	  : in	std_logic;
	oe	  :	in	std_logic;
	we	  :	in	std_logic;
	index : in	std_logic_vector(INDEX_WIDTH-1 downto 0);
	din	  :	in	std_logic_vector(BIT_WIDTH-1 downto 0);
	dout  :	out std_logic_vector(BIT_WIDTH-1 downto 0)
  );
end csram;

architecture behavioral of csram is
begin
  process (cs, oe, we, index)
    type Cell;
    type CellPtr is access Cell;
    type Cell is
    record
      nextCell : CellPtr;
      addr : std_logic_vector(INDEX_WIDTH-1 downto 0);
      word : stD_logic_vector(BIT_WIDTH-1 downto 0);
    end record;

    procedure setWord (
      head : inout CellPtr;
      addr : in std_logic_vector(INDEX_WIDTH-1 downto 0);
      word : in std_logic_vector(BIT_WIDTH-1 downto 0)
    ) is
    variable ptr : CellPtr;
    begin
      ptr := head;
      while ptr /= head loop
        if ptr.addr = addr then
          ptr.word := word;
          return;
        end if;
      end loop;
      ptr := new Cell'(nextCell => head, addr => addr, word => word);
      head := ptr;
    end setWord;

    procedure getWord (
      head : inout CellPtr;
      addr : in std_logic_vector(INDEX_WIDTH-1 downto 0);
      word : out std_logic_vector(BIT_WIDTH-1 downto 0)
    ) is
    variable ptr : CellPtr;
    begin
      ptr := head;
      while ptr /= null loop
        if ptr.addr = addr then
          word := ptr.word;
          return;
        end if;
        ptr := ptr.nextCell;
      end loop;
      word := (others => '0');
    end getWord;

    -- Debug support procedure.
    function to_string(sv : std_logic_vector) return string is
      variable bv : bit_vector(sv'range) := to_bitvector(sv);
      variable lp : line;
    begin
      write(lp, bv);
      return lp.all;
    end;

    variable head : CellPtr := null;
    variable dbuf : std_logic_vector(BIT_WIDTH-1 downto 0);
    begin
      if cs = '1' then
        if we = '1' then
          setWord(head, index, din);
        end if;
        if oe = '1' then
          getWord(head, index, dbuf);
          dout <= dbuf;
        end if;
      end if;
  end process;
end behavioral;
