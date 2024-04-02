library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2x1_tb is
end;

architecture mux_2x1_tb_arq of mux_2x1_tb is

  -- Component
  component mux_2x1 is
    port(
      a_i : in  std_logic_vector(3 downto 0);
      b_i : in  std_logic_vector(3 downto 0);
      s_i : in  std_logic;
      s_o : out std_logic_vector(3 downto 0)
      );
  end component;

  -- Testing variables
  signal a_tb  : std_logic_vector(3 downto 0) := "1011";
  signal b_tb  : std_logic_vector(3 downto 0) := "0100";
  signal si_tb : std_logic                    := '0';
  signal so_tb : std_logic_vector(3 downto 0);

begin

  -- Device under testing
  DUT : mux_2x1
    port map(
      a_i => a_tb,
      b_i => b_tb,
      s_i => si_tb,
      s_o => so_tb
      );

  -- Stimulus process
  stimulus_process : process
  begin

    -- When SI = '0' the output should be A
    a_tb  <= "0001";
    b_tb  <= "0101";
    si_tb <= '0';
    wait for 10 ns;
    assert so_tb = "0001" report "Expected signal 'A' take precedence as 'SI' is zero." severity error;

    -- When SI = '1' the output should be B
    a_tb  <= "0001";
    b_tb  <= "0101";
    si_tb <= '1';
    wait for 10 ns;
    assert so_tb = "0101" report "Expected signal 'B' take precedence as 'SI' is one." severity error;

  end process stimulus_process;

end;
