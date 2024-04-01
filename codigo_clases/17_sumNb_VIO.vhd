library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sumNb_VIO is
  port(
    clk_i : in std_logic
    );
end;

architecture sumNb_VIO_arq of sumNb_VIO is
  -- Parte declarativa

  component vio_0
    port (
      clk        : in  std_logic;
      probe_in0  : in  std_logic_vector(3 downto 0);
      probe_in1  : in  std_logic_vector(0 downto 0);
      probe_out0 : out std_logic_vector(3 downto 0);
      probe_out1 : out std_logic_vector(3 downto 0);
      probe_out2 : out std_logic_vector(0 downto 0)
      );
  end component;

  signal probe_a  : std_logic_vector(3 downto 0);
  signal probe_b  : std_logic_vector(3 downto 0);
  signal probe_ci : std_logic;
  signal probe_s  : std_logic_vector(3 downto 0);
  signal probe_co : std_logic;

begin
  -- Parte descriptiva

  sumNb_inst : entity work.sumNb
    generic map(
      N => 4
      )
    port map(
      a_i  => probe_a,
      b_i  => probe_b,
      ci_i => probe_ci,
      s_o  => probe_s,
      co_o => probe_co
      );

  VIO_inst : vio_0
    port map (
      clk           => clk_i,
      probe_in0     => probe_s,
      probe_in1(0)  => probe_co,
      probe_out0    => probe_a,
      probe_out1    => probe_b,
      probe_out2(0) => probe_ci
      );


end;
