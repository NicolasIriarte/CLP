library IEEE;
use IEEE.std_logic_1164.all;

entity sum4b_tb is
end;

architecture sum4b_tb_arq of sum4b_tb is

	-- Component
  component sum4b is
    port(
      a_i: in std_logic_vector(3 downto 0);
      b_i: in std_logic_vector(3 downto 0);
      ci_i: in std_logic;
      s_o: out std_logic_vector(3 downto 0);
      co_o: out std_logic
      );
  end component;

	-- Testing variables
	signal a_tb: std_logic_vector(3 downto 0) := "1011";
	signal b_tb: std_logic_vector(3 downto 0) := "0100";
	signal ci_tb: std_logic := '0';
	signal s_tb: std_logic_vector(3 downto 0);
	signal co_tb: std_logic;

begin

  -- Device under testing
	DUT: sum4b
		port map(
			a_i	 => a_tb,
			b_i	 => b_tb,
			ci_i => ci_tb,
			s_o	 => s_tb,
			co_o => co_tb
		);

  -- Stimulus process
  stimulus_process: process
  begin

    -- Test case 1: 1 + 1 = 2
    a_tb <= "0001";
    b_tb <= "0001";
    ci_tb <= '0';
    wait for 10 ns;
    assert s_tb = "0010" report "1. Test case 1 failed: Expected value '2'" severity error;
    assert co_tb = '0' report "2. Test case 1 failed: Expected no CO" severity error;

    -- Test case 2: Multiple bits
    a_tb <= "1101";
    b_tb <= "0010";
    ci_tb <= '0';
    wait for 10 ns;
    assert s_tb = "1111" report "1. Test case 2 failed" severity error;
    assert co_tb = '0' report "2. Test case 2 failed" severity error;

    -- Test case 3: Use CO
    a_tb <= "1111";
    b_tb <= "0001";
    ci_tb <= '0';
    wait for 10 ns;
    assert s_tb = "0000" report "1. Test case 3 failed" severity error;
    assert co_tb = '1' report "2. Test case 3 failed" severity error;

    -- Test case 4: Use all bits
    a_tb <= "1111";
    b_tb <= "1111";
    ci_tb <= '1';
    wait for 10 ns;
    assert s_tb = "1111" report "1. Test case 4 failed" severity error;
    assert co_tb = '1' report "2. Test case 4 failed" severity error;

  end process stimulus_process;

end;
