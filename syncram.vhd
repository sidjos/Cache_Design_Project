library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use ieee.numeric_std.all;

-- With reference to http://www.dte.us.es/ing_inf/dise_comp/VHDLsimCMSG.pdf
-- Sparse SRAM

entity syncram is
  generic (
	mem_file : string
  );
  port (
    clk   : in  std_logic;
	cs	  : in	std_logic;
	oe	  :	in	std_logic;
	we	  :	in	std_logic;
	addr  : in	std_logic_vector(31 downto 0);
	din	  :	in	std_logic_vector(31 downto 0);
	dout  :	out std_logic_vector(31 downto 0)
  );
end syncram;

architecture behavioral of syncram is
begin
  process (clk)
    type Cell;
    type CellPtr is access Cell;
    type Cell is
    record
      nextCell : CellPtr;
      addr : std_logic_vector(31 downto 0);
      word : stD_logic_vector(31 downto 0);
    end record;

    procedure getWord (
      head : inout CellPtr;
      addr : in std_logic_vector(31 downto 0);
      word : out std_logic_vector(31 downto 0)
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
      word := (others => 'U');
    end getWord;

    procedure setWord (
      head : inout CellPtr;
      addr : in std_logic_vector(31 downto 0);
      word : in std_logic_vector(31 downto 0)
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
    -- Borrows from std_logic_textio from synopsys.
    procedure Char2QuadBits(C: Character; 
				RESULT: out Bit_Vector(3 downto 0);
				GOOD: out Boolean;
				ISSUE_ERROR: in Boolean) is
	begin
		case c is
			when '0' => result :=  x"0"; good := TRUE;
			when '1' => result :=  x"1"; good := TRUE;
			when '2' => result :=  x"2"; good := TRUE;
			when '3' => result :=  x"3"; good := TRUE;
			when '4' => result :=  x"4"; good := TRUE;
			when '5' => result :=  x"5"; good := TRUE;
			when '6' => result :=  x"6"; good := TRUE;
			when '7' => result :=  x"7"; good := TRUE;
			when '8' => result :=  x"8"; good := TRUE;
			when '9' => result :=  x"9"; good := TRUE;
			when 'A' => result :=  x"A"; good := TRUE;
			when 'B' => result :=  x"B"; good := TRUE;
			when 'C' => result :=  x"C"; good := TRUE;
			when 'D' => result :=  x"D"; good := TRUE;
			when 'E' => result :=  x"E"; good := TRUE;
			when 'F' => result :=  x"F"; good := TRUE;
 
			when 'a' => result :=  x"A"; good := TRUE;
			when 'b' => result :=  x"B"; good := TRUE;
			when 'c' => result :=  x"C"; good := TRUE;
			when 'd' => result :=  x"D"; good := TRUE;
			when 'e' => result :=  x"E"; good := TRUE;
			when 'f' => result :=  x"F"; good := TRUE;
			when others =>
			   if ISSUE_ERROR then 
				   assert FALSE report
					"HREAD Error: Read a '" & c &
					   "', expected a Hex character (0-F).";
			   end if;
			   good := FALSE;
		end case;
	end;

    -- Debug support procedure.
    function to_string(sv : std_logic_vector) return string is
      variable bv : bit_vector(sv'range) := to_bitvector(sv);
      variable lp : line;
    begin
      write(lp, bv);
      return lp.all;
    end;

    procedure HREADPlus (
      l     : inout line;
      value : out std_logic_vector;
      good  : out boolean
    ) is
      variable c      : character;
      variable ok     : boolean;
      constant ne     : integer := value'length / 4;
      variable buf    : std_logic_vector(value'length-1 downto 0);
      variable bitbuf : bit_vector(3 downto 0);
    begin
      good := false;
      if value'length mod 4 /= 0 then
        return;
      end if;

      buf := (others => '0');
      main : loop
        read(l, c);
        exit when not
          (  (c >= '0' and c <= '9')
          or (c >= 'A' and c <= 'F')
          or (c >= 'a' and c <= 'f'));
        Char2QuadBits(c, bitbuf(3 downto 0), ok, false);
        if ok then
          good := true;
        end if;
        exit main when not ok;
        buf := buf(27 downto 0) & To_X01(bitbuf);
      end loop;
      value := buf;
      return;
    end procedure;

    procedure initRAM (
      mem_file : in string;
      head : inout CellPtr
    ) is
    file infile : TEXT open read_mode is mem_file;
    -- file infile : text is in mem_file;
    variable inline : Line;
    variable inaddr : std_logic_vector(31 downto 0);
    variable indata : std_logic_vector(31 downto 0);
    variable slash : character; --  string(7 downto 1);
    variable semicolon : string(17 downto 1);
    variable good : boolean;
    begin
      scanloop : while not endfile(infile) loop
        readline(infile, inline);
        next scanloop when inline'length = 0;
        HREADPlus(inline, inaddr, good);
        next scanloop when not good;
        read_data : loop
          HREADPlus(inline, indata, good);
          exit read_data when good;
        end loop read_data;

        setWord(head, inaddr, indata);
      end loop scanloop;
    end initRAM;

    variable head : CellPtr;
    variable needInit : boolean := true;
    variable dbuf : std_logic_vector(31 downto 0);
    begin
      if needInit then
        initRAM(mem_file, head);
        needInit := false;
      end if;
      if rising_edge(clk) then
          if cs = '1' then
            if oe = '1' then
              getWord(head, addr, dbuf);
              dout <= dbuf;
            end if;
            if we = '1' then
              setWord(head, addr, din);
            end if;
          end if;
      end if;
  end process;
end behavioral;
