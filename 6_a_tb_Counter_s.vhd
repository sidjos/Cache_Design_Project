library IEEE;
use IEEE.std_logic_1164.all; -- std_logic
--Additional standard or custom libraries go here
entity Counter_tb is
  port (
    F_tb : out std_logic_vector(31 downto 0) := X"00_00_00_00"
  );
end entity Counter_tb;

architecture behavioral of Counter_tb is
--Entity (as component) and input ports (as signals) go here
component Counter_s is
  port (
    FA_1or0   : in std_logic;
    Clk_ip    : in std_logic;
    Reset     : in std_logic;
    FA_ip_op   : out std_logic_vector(31 downto 0)
    );
end component Counter_s;
--component declaration and stimuli processes go here
  signal FA_1or0_s, Clk_ip_s, Reset_s : std_logic := '0';

begin 
  DUT : Counter_s
    port map(FA_1or0_s, Clk_ip_s, Reset_s, F_tb);
-- start simulate Clk
    simulate_clk : process is
    begin
      Reset_s <= '1';
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Reset_s <= '0';
                                                           
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                                    
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                                          
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                                          
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;
      Clk_ip_s <= '0'; wait for 5 ns; Clk_ip_s <= '1'; wait for 5 ns;                              




      wait;
    end process simulate_clk;
-- end simulate Clk

-- start simulate Out
    simulate_out : process is
    begin 

      FA_1or0_s <= '0'; wait for 20 ns;
      FA_1or0_s <= '1'; wait for 10 ns;

      wait;
    end process simulate_out;
-- end simulate Out    
end architecture behavioral;
