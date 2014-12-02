-- Level 1 Cache

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity L1$ is 
   port 
       (
       Data_In: in std_logic_vector ( 31 downto 0);
       Address: in std_logic_vector ( 31 downto 0);
       Data_Valid_L2: in std_logic;
       Hit : out std_logic;
       Data_Out: out std_logic_vector ( 31 downto 0)
       );
end L1$;
       
architecture structural of L1$ is 
 
 component csram is
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
    end component;
    
    signal L1_Block_Out, L1_Block_In: std_logic_vector ( 534 downto 0);
    
begin 

L1_csram: csram generic map ( INDEX_WIDTH => 4; BIT_WIDTH => 535 );
                port map ( cs => '1'; oe => '1'; we => WrEn_L1; index => Address(9:6); din => L1_Block_In; dout => L1_Block_Out);




end architecture structural; 