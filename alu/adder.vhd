library IEEE;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;

-- We are programming on VHDL. This is a VHDL file.

entity adder is
  port(
    instruction_i : in  std_logic_vector(31 downto 0);
    rs1_i         : in  std_logic_vector(31 downto 0);
    rs2_i         : in  std_logic_vector(31 downto 0);
    result_o      : out std_logic_vector(31 downto 0);
    icc_o         : out std_logic_vector(3 downto 0)
    );
end;

architecture adder_arq of adder is
  signal operand2 : std_logic_vector(31 downto 0) := (others => '0');
  signal result   : std_logic_vector(31 downto 0) := (others => '0');

  function plus(A, B : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable carry : std_ulogic;
    variable sum   : std_logic_vector(31 downto 0);
  begin
    carry := '0';

    for i in 0 to 31 loop
      sum(i) := A(i) xor B(i) xor carry;
      carry  := (A(i) and B(i)) or (A(i) and carry) or (carry and B(i));
    end loop;
    return sum;
  end;

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
  -- operand2 := if (i = 0) then r[rs2] else sign_extend(simm13); INFO: (A)
  --
  -- if (ADD or ADDcc) then INFO: Always TRUE
  --   result ← r[rs1] + operand2; INFO: (B)
  -- else if (ADDX or ADDXcc) then
  --   result ← r[rs1] + operand2 + C;
  --
  -- next;
  --
  -- if (rd ≠ 0) then INFO: We assume always TRUE
  --   r[rd] ← result; INFO: (C)
  --
  -- if (ADDcc or ADDXcc) then ( INFO: Always TRUE
  --   N ← result<31>; INFO: (D)
  --
  --   Z ← if (result = 0) then 1 else 0; INFO: (E)
  --
  --   INFO: (F)
  --   V ← (r[rs1]<31> and operand2<31> and (not result<31>)) or
  --       ((not r[rs1]<31>) and (not operand2<31>) and result<31>);
  --
  --   INFO: (G)
  --   C ← (r[rs1]<31> and operand2<31>) or
  --       ((not result<31>) and (r[rs1]<31> or operand2<31>))
  -- );

  -- BEGIN: (A)
  -- Check the 13bit of `instruction_i`
  process(instruction_i, rs1_i, rs2_i)
  begin
    if instruction_i(13) = '0' then
      operand2 <= rs2_i;
    else
      -- Move the last 13bits of `instruction_i` to `operand2`
      operand2 <= (31 downto 13 => '0') & instruction_i(12 downto 0);
    end if;
  end process;

  -- BEGIN: (B)
  -- Calculate the addition and assing to `result`
  result <= plus(rs1_i, operand2);

  -- BEGIN: (C)
  -- Assing the result to `result_o`
  result_o <= result;

  -- BEGIN: (D)
  -- Assing the 31bit of `result` to `icc_o(3)`
  icc_o(3) <= result(31);

  -- BEGIN: (E)
  -- Assing the 0 or 1 to `icc_o`
  icc_o(2) <= '1' when result = "00000000000000000000000000000000" else '0';

  -- BEGIN: (F)
  -- Assing the V to `icc_o`
  -- process(rs1_i, operand2, result)
  -- begin
  --   report "RS1:      " & debug_vector_as_string(rs1_i);
  --   report "operand2: " & debug_vector_as_string(operand2);
  --   report "result:   " & debug_vector_as_string(result);
  --   report "-----------";
  -- end process;

  icc_o(1) <= (rs1_i(31) and operand2(31) and (not result(31))) or
              ((not rs1_i(31)) and (not operand2(31)) and result(31));

  -- BEGIN: (G)
  -- Assing the C to `icc_o`
  icc_o(0) <= (rs1_i(31) and operand2(31)) or
              ((not result(31)) and (rs1_i(31) or operand2(31)));

end;
