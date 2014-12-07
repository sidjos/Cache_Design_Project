library ieee;
use ieee.std_logic_1164.all;

entity rightshifter_32to32_s is
  port (
    ctrl  : in std_logic_vector(4 downto 0);
    y     : in std_logic;
    x     : in std_logic_vector(31 downto 0);
    z     : out std_logic_vector(31 downto 0)
  );
end rightshifter_32to32_s;

architecture rightshifter_32to32_s_str of rightshifter_32to32_s is
  signal mux_so_1l, mux_so_2l, mux_so_3l, mux_so_4l, 
    mux_so_5l : std_logic_vector(31 downto 0);
begin 
  -- 1st level 1 ###################################################################
  gen_loop_1 : for i in 0 to 31 generate
    mux_1l_y : if i = 31  generate 
      mux_1l_y_g : entity work.mux
        port map(ctrl(0), x(31), y, mux_so_1l(31));
    end generate;

    mux_1l_x : if i /= 31 generate
      mux_1l_x_g : entity work.mux
        port map(ctrl(0), x(i), x(i + 1), mux_so_1l(i));
    end generate;
  end generate;

  -- 2nd level 2 ##################################################################
  gen_loop_2 : for i in 0 to 31 generate
    mux_2l_y : if i >= 30 generate 
      mux_2l_y_g : entity work.mux
        port map(ctrl(1), mux_so_1l(i), y, mux_so_2l(i));
      end generate;

    mux_2l_x : if i <= 29 generate 
      mux_2l_x_g : entity work.mux
        port map(ctrl(1), mux_so_1l(i), mux_so_1l(i + 2), mux_so_2l(i));
      end generate;
  end generate;

  -- 3rd level 4 ##################################################################
  gen_loop_3 : for i in 0 to 31 generate
    mux_3l_y : if i >= 28 generate 
      mux_3l_y_g : entity work.mux
        port map(ctrl(2), mux_so_2l(i), y, mux_so_3l(i));
    end generate;

    mux_3l_x : if i <= 27 generate
      mux_3l_x_g : entity work.mux
        port map(ctrl(2), mux_so_2l(i), mux_so_2l(i + 4), mux_so_3l(i));
    end generate;
  end generate;

  -- 4th level 8 ##################################################################
  gen_loop_4 : for i in 0 to 31 generate
    mux_4l_y : if i >= 24 generate 
      mux_4l_y_g : entity work.mux
        port map(ctrl(3), mux_so_3l(i), y, mux_so_4l(i));
    end generate;

    mux_4l_x : if i <= 23 generate
      mux_4l_x_g : entity work.mux
        port map(ctrl(3), mux_so_3l(i), mux_so_3l(i + 8), mux_so_4l(i));
    end generate;
  end generate;

  -- 5th level 16 ##################################################################
  gen_loop_5 : for i in 0 to 31 generate
    mux_5l_y : if i >= 16 generate 
      mux_3l_y_g : entity work.mux
        port map(ctrl(4), mux_so_4l(i), y, z(i));
    end generate;

    mux_5l_x : if i <= 15 generate
      mux_3l_x_g : entity work.mux
        port map(ctrl(4), mux_so_4l(i), mux_so_4l(i + 16), z(i));
    end generate;
  end generate;  

end architecture rightshifter_32to32_s_str;