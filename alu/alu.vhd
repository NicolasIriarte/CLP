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

  constant ADD_OPCODE : std_logic_vector(5 downto 0) := "010000";
  constant SUB_OPCODE : std_logic_vector(5 downto 0) := "000100";

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

  -- Declare signals for adder and subtractor results
  signal adder_result : std_logic_vector(31 downto 0);
  signal adder_icc    : std_logic_vector(3 downto 0);

  signal subtractor_result : std_logic_vector(31 downto 0) := (others => '0');
  signal subtractor_icc    : std_logic_vector(3 downto 0)  := (others => '0');


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

  -- Use a case statement to select the result based on the instruction
  process(instruction_i, rs1_i, rs2_i)
  begin
    case instruction_i(24 downto 19) is
      when ADD_OPCODE =>
        report "Performing addition" severity warning;
        rd_o  <= adder_result;
        icc_o <= adder_icc;
      when SUB_OPCODE =>
        report "Performing subtraction" severity warning;
        rd_o  <= adder_result;
        icc_o <= adder_icc;
      -- rd_o  <= subtractor_result;
      -- icc_o <= subtractor_icc;
      when others =>                    -- Default case (e.g., subtraction)
        -- If the instruction is zero or has unsettled bits, do nothing.
        report "Invalid OPCODE: 0b" & debug_vector_as_string(instruction_i(24 downto 19)) severity warning;
    end case;
  end process;


end;
