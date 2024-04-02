library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2x1 is
  port(
    a_i : in  std_logic_vector(3 downto 0);
    b_i : in  std_logic_vector(3 downto 0);
    s_i : in  std_logic;
    s_o : out std_logic_vector(3 downto 0)
    );
end;

architecture mux_2x1_arq of mux_2x1 is
begin
  -- When s_i is '0', then s_o is equal to a_i
  -- When s_i is '1', then s_o is equal to b_i
  s_o <= a_i when s_i = '0' else b_i;

end;
