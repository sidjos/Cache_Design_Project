library IEEE;
use IEEE.std_logic_1164.all; -- std_logic
--Additional standard or custom libraries go here
entity lru_counter_to_offset_tb is
  port (
    F_tb : out std_logic_vector(3 downto 0)
  );
end entity lru_counter_to_offset_tb;

architecture behavioral of lru_counter_to_offset_tb is
--Entity (as component) and input ports (as signals) go here
component lru_counter_to_offset_s is
  port ( 
    Update : in std_logic;
    Rd     : in std_logic_vector(3 downto 0);
    Wr     : in std_logic_vector(3 downto 0);
    Reset  : in std_logic;
    Wr_o   : out std_logic_vector(3 downto 0)
    );
  end component lru_counter_to_offset_s;
--component declaration and stimuli processes go here
  signal update_s, Reset_s : std_logic := '0';
  signal Rd_s, Wr_s : std_logic_vector(3 downto 0);
begin 
  DUT : lru_counter_to_offset_s
    port map(update_s, Rd_s, Wr_s, Reset_s, F_tb);

    simulate_all : process is
    begin 
      Reset_s <= '1';
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      Reset_s <= '0'; 

      Wr_s <= B"0000"; Rd_s <= B"0000"; 
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      Wr_s <= B"1000"; Rd_s <= B"1000"; 
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      Wr_s <= B"0100"; Rd_s <= B"0100"; 
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      Wr_s <= B"0010"; Rd_s <= B"0010"; 
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      

      Wr_s <= B"0001"; Rd_s <= B"0001"; 
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      

      Wr_s <= B"0000"; Rd_s <= B"1000"; 
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      
      Wr_s <= B"0000"; Rd_s <= B"0000"; 

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;                              
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;                              

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      wait;
    end process simulate_all;
end architecture behavioral;
