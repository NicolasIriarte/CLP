library IEEE;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;

-- We are programming on VHDL. This is a VHDL file.

entity alu is
  port(
    instruction_i : in  std_logic_vector(31 downto 0);
    rs1_i         : in  std_logic_vector(31 downto 0);
    rs2_i         : in  std_logic_vector(31 downto 0);
    rd_o          : out std_logic_vector(31 downto 0);
    icc_o         : out std_logic_vector(3 downto 0)
    );

-- Sum

-- Resta
-- Mult
-- Desplazamiento
end;

architecture alu_arq of alu is

  constant ADD_OPCODE  : std_logic_vector(5 downto 0) := "010000";
  constant SUB_OPCODE  : std_logic_vector(5 downto 0) := "000100";
  constant UMUL_OPCODE : std_logic_vector(5 downto 0) := "011010";
  constant SMUL_OPCODE : std_logic_vector(5 downto 0) := "011011";


  component adder is
    port(
      instruction_i : in  std_logic_vector(31 downto 0);
      rs1_i         : in  std_logic_vector(31 downto 0);
      rs2_i         : in  std_logic_vector(31 downto 0);
      result_o      : out std_logic_vector(31 downto 0);
      icc_o         : out std_logic_vector(3 downto 0)
      );
  end component;

  component subtractor is
    port(
      instruction_i : in  std_logic_vector(31 downto 0);
      rs1_i         : in  std_logic_vector(31 downto 0);
      rs2_i         : in  std_logic_vector(31 downto 0);
      result_o      : out std_logic_vector(31 downto 0);
      icc_o         : out std_logic_vector(3 downto 0)
      );
  end component;

  component multiplicator is
    port(
      instruction_i : in  std_logic_vector(31 downto 0);
      rs1_i         : in  std_logic_vector(31 downto 0);
      rs2_i         : in  std_logic_vector(31 downto 0);
      result_o      : out std_logic_vector(31 downto 0);
      icc_o         : out std_logic_vector(3 downto 0)
      );
  end component;

  -- Declare signals for adder and subtractor results
  signal adder_result : std_logic_vector(31 downto 0) := (others => '0');
  signal adder_icc    : std_logic_vector(3 downto 0)  := (others => '0');

  signal subtractor_result : std_logic_vector(31 downto 0) := (others => '0');
  signal subtractor_icc    : std_logic_vector(3 downto 0)  := (others => '0');

  signal multiplicator_result : std_logic_vector(31 downto 0) := (others => '0');
  signal multiplicator_icc    : std_logic_vector(3 downto 0)  := (others => '0');


  -- Helpers
  function debug_vector_as_string (a : std_logic_vector) return string is
    variable b    : string (1 to a'length) := (others => NUL);
    variable stri : integer                := 1;
  begin
    for i in a'range loop
      b(stri) := std_logic'image(a((i)))(2);
      stri    := stri+1;
    end loop;
    return b;
  end function;

begin
  adder_instance : adder
    port map (
      instruction_i => instruction_i,
      rs1_i         => rs1_i,
      rs2_i         => rs2_i,
      result_o      => adder_result,
      icc_o         => adder_icc
      );

  subtractor_instance : subtractor
    port map (
      instruction_i => instruction_i,
      rs1_i         => rs1_i,
      rs2_i         => rs2_i,
      result_o      => subtractor_result,
      icc_o         => subtractor_icc
      );

  multiplicator_instance : multiplicator
    port map (
      instruction_i => instruction_i,
      rs1_i         => rs1_i,
      rs2_i         => rs2_i,
      result_o      => multiplicator_result,
      icc_o         => multiplicator_icc
      );

  -- Use a case statement to select the result based on the instruction
  rd_o <= adder_result when (instruction_i(24 downto 19) = ADD_OPCODE) else
          subtractor_result when (instruction_i(24 downto 19) = SUB_OPCODE) else
          multiplicator_result when ((instruction_i(24 downto 19) = UMUL_OPCODE) or
                                     (instruction_i(24 downto 19) = SMUL_OPCODE)) else
          subtractor_result;

  icc_o <= adder_icc when (instruction_i(24 downto 19) = ADD_OPCODE) else
           subtractor_icc when (instruction_i(24 downto 19) = SUB_OPCODE) else
           multiplicator_icc when ((instruction_i(24 downto 19) = UMUL_OPCODE) or
                                   (instruction_i(24 downto 19) = SMUL_OPCODE)) else
           subtractor_icc;

end;
