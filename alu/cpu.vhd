library IEEE;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;

-- We are programming on VHDL. This is a VHDL file.
entity cpu is
  port(
    a_i : in  std_logic;
    b_o : out std_logic
    );
end;

architecture cpu_arq of cpu is
  component alu is
    port(
      instruction_i : in  std_logic_vector(31 downto 0);
      rs1_i         : in  std_logic_vector(31 downto 0);
      rs2_i         : in  std_logic_vector(31 downto 0);
      rd_o          : out std_logic_vector(31 downto 0);
      icc_o         : out std_logic_vector(3 downto 0)
      );
  end component;

  signal alu_inputs : std_logic_vector(95 downto 0) := (others => '0');

  alias alu_instruction_in : std_logic_vector(31 downto 0) is alu_inputs(95 downto 64);
  alias alu_rs1_in         : std_logic_vector(31 downto 0) is alu_inputs(63 downto 32);
  alias alu_rs2_in         : std_logic_vector(31 downto 0) is alu_inputs(31 downto 0);
  signal alu_rd_out        : std_logic_vector(31 downto 0) := (others => '0');
  signal alu_icc_out       : std_logic_vector(3 downto 0)  := (others => '0');

  signal counter : unsigned(95 downto 0) := (others => '0');

begin

  alu_instance : alu
    port map (
      instruction_i => alu_instruction_in,
      rs1_i         => alu_rs1_in,
      rs2_i         => alu_rs2_in,
      rd_o          => alu_rd_out,
      icc_o         => alu_icc_out
      );

  process(a_i)
  begin
    counter <= counter + 1;
    alu_inputs <= std_logic_vector(counter);

    b_o <= alu_rd_out(0);
  end process;


end;
