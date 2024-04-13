library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu_tb is
end;

-- Tests propuestos:
--
-- - Addition
--   - Using RS1 y RS2.
--     - [x] [A00] Addition of two positive numbers.
--     - [x] [A01] Check SIMM13 doesn't interfere when I = 0.
--     - [x] [A02] Addition of positive and negative numbers.
--     - [x] [A03] Addition where the result is negative.
--     - [x] [A04] Overflow flag is correctly set.
--   - Can select between SIMM13 and RS2 changing I.
--     - [x] [A10] Check RS2 doesn't interfere when I = 1.

-- - Subtraction
--   - Using RS1 y RS2.
--     - [x] [S00] Subtraction of two positive numbers.
--     - [x] [S01] Check SIMM13 doesn't interfere when I = 0.
--     - [x] [S02] Subtraction of positive and negative numbers.
--     - [x] [S03] Subtraction where the result is negative.
--     - [x] [S04] Overflow flag is correctly set.
--   - Can select between SIMM13 and RS2 changing I.
--     - [x] [S10] Check RS2 doesn't interfere when I = 1.

-- - Multiplication
--   - [x] [M00] Signed multiplication between two positive numbers.
--   - [x] [M01] Signed multiplication between two negative numbers.
--   - [x] [M02] Signed multiplication between a positive and a negative number.
--   - [x] [M03] Signed multiplication between a negative and a positive number.
--   - [x] [M04] Unsigned multiplication works properly.



architecture alu_tb_arq of alu_tb is

  -- Declaracion de componente
  component alu is
    port(
      instruction_i : in  std_logic_vector(31 downto 0);
      rs1_i         : in  std_logic_vector(31 downto 0);
      rs2_i         : in  std_logic_vector(31 downto 0);
      rd_o          : out std_logic_vector(31 downto 0);
      icc_o         : out std_logic_vector(3 downto 0)
      );
  end component;

  -- Declaracion de senales de prueba
  signal instruction_tb : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal rs1_tb         : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal rs2_tb         : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal rd_tb          : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal icc_tb         : std_logic_vector(3 downto 0)  := "0000";

  signal expected_value : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

begin

  -- Device under testing
  DUT : alu
    port map(
      instruction_i => instruction_tb,
      rs1_i         => rs1_tb,
      rs2_i         => rs2_tb,
      rd_o          => rd_tb,
      icc_o         => icc_tb
      );

  -- Stimulus process
  stimulus_process : process
  begin
    -- ----------------------------------------------------------------
    -- ------------------------- ADDITION -----------------------------
    -- ----------------------------------------------------------------

    -- Given a valid SUM instruction add its values
    instruction_tb <= "01" &            -- OP
                      "00000" &  -- RD (Ignored as windows are not implemented)
                      "010000" &        -- OP3 (Opcode of the instriction)
                      "00000" &         --RS1
                      "0" &             -- I value
                      "00000000" &      -- ASI (UNUSED)
                      "00011"  -- RS2 (Ignored as windows are not implemented)
;

    -- icc_tb <=
    --   -- N indicates whether the 32-bit 2’s complement ALU result was negative
    --   -- for the last instruction that modified the icc field. 1 = negative, 0 =
    --   -- not negative.
    --   "0" &
    --   -- Z indicates whether the 32-bit ALU result was zero for the last
    --   -- instruction that modified the icc field. 1 = zero, 0 = nonzero.
    --   "0" &
    --   -- V indicates whether the ALU result was within the range of (was
    --   -- represent- able in) 32-bit 2’s complement notation for the last
    --   -- instruction that modified the icc field. 1 = overflow, 0 = no overflow.
    --   "0" &
    --   -- C indicates whether a 2’s complement carry out (or borrow) occurred for
    --   -- the last instruction that modified the icc field. Carry is set on
    --   -- addition if there is a carry out of bit 31. Carry is set on subtraction
    --   -- if there is borrow into bit 31. 1 = carry, 0 = no carry.
    --   "0";

    ----------------------------------------------------------------------------
    -- Test case [A00] Addition of two positive numbers.
    ----------------------------------------------------------------------------

    rs1_tb         <= "00000000000000000000000000001100";  --   12
    rs2_tb         <= "00000000000000000000000000000011";  -- +  3
    --                                                     -- -----
    expected_value <= "00000000000000000000000000001111";  --   15

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced sum of '12' and '3' be '15'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '0' report "Expect a Non-negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect not-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect no overflow" severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect no carry" severity error;

    ----------------------------------------------------------------------------
    -- Test case [A02] Addition of positive and negative numbers.
    ----------------------------------------------------------------------------

    rs1_tb         <= "11111111111111111111111111111101";  --   -3
    rs2_tb         <= "00000000000000000000000000000011";  -- +  3
    --                                                     -- -----
    expected_value <= "00000000000000000000000000000000";  --    0

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced sum of '-3' and '3' be '0'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '0' report "Expect a Non-negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '1' report "Expect zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect no overflow" severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '1' report "Expect carry" severity error;

    ----------------------------------------------------------------------------
    -- Test case [A03] Addition where the result is negative.
    ----------------------------------------------------------------------------

    rs1_tb         <= "11111111111111111111111111111101";  --   -3
    rs2_tb         <= "00000000000000000000000000000001";  -- +  1
    --                                                     -- -----
    expected_value <= "11111111111111111111111111111110";  --   -2

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced sum of '-3' and '1' be '-2'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '1' report "Expect a negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect non-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect no overflow" severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect no carry" severity error;

    ----------------------------------------------------------------------------
    -- Test case [A01] Check SIMM13 doesn't interfere when I = 0.
    -- Test case [A04] Overflow flag is correctly set.
    ----------------------------------------------------------------------------

    rs1_tb         <= "11111111111111111111111111111111";  --   0xFFFFFFFF
    rs2_tb         <= "10000000000000000000000000000000";  -- + 0x80000000
    --                                                     -- -------------
    expected_value <= "01111111111111111111111111111111";  --   0x7FFFFFFF

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced sum of '0xFFFFFFFF' and '0x80000000' be '0x7FFFFFFF'." severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '0' report "Expect a negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '1' report "Expect overflow" severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '1' report "Expect no carry" severity error;

    ----------------------------------------------------------------------------
    -- Test case [A10] Check RS2 doesn't interfere when I = 1.
    ----------------------------------------------------------------------------

    -- Given a valid SUM instruction add its values
    instruction_tb <= "01" &            -- OP
                      "00000" &  -- RD (Ignored as windows are not implemented)
                      "010000" &        -- OP3 (Opcode of the instriction)
                      "00000" &         -- RS1
                      "1" &             -- I value
                      "0000000000011"   -- SIMM13
;

    rs1_tb         <= "00000000000000000000000000001100";  --   12
    rs2_tb         <= "00000000000000000000000000001111";  -- + 15 (RS2 IGNORED!)
    -- simm13         "00000000000000000000000000000011"   --    3
    --                                                     -- -----
    expected_value <= "00000000000000000000000000001111";  --   15

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced sum of '12' and '3' be '15'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '0' report "Expect a Non-negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect not-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect no overflow" severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect no carry" severity error;

    -- ----------------------------------------------------------------
    -- ----------------------- SUBTRACTION ----------------------------
    -- ----------------------------------------------------------------

    -- Given a valid SUM instruction add its values
    instruction_tb <= "01" &            -- OP
                      "00000" &  -- RD (Ignored as windows are not implemented)
                      "010100" &        -- OP3 (Opcode of the instriction)
                      "00000" &         --RS1
                      "0" &             -- I value
                      "00000000" &      -- ASI (UNUSED)
                      "00011"  -- RS2 (Ignored as windows are not implemented)
;


    -- icc_tb <=
    --   -- N indicates whether the 32-bit 2’s complement ALU result was negative
    --   -- for the last instruction that modified the icc field. 1 = negative, 0 =
    --   -- not negative.
    --   "0" &
    --   -- Z indicates whether the 32-bit ALU result was zero for the last
    --   -- instruction that modified the icc field. 1 = zero, 0 = nonzero.
    --   "0" &
    --   -- V indicates whether the ALU result was within the range of (was
    --   -- represent- able in) 32-bit 2’s complement notation for the last
    --   -- instruction that modified the icc field. 1 = overflow, 0 = no overflow.
    --   "0" &
    --   -- C indicates whether a 2’s complement carry out (or borrow) occurred for
    --   -- the last instruction that modified the icc field. Carry is set on
    --   -- subtraction if there is a carry out of bit 31. Carry is set on subtraction
    --   -- if there is borrow into bit 31. 1 = carry, 0 = no carry.
    --   "0";

    ----------------------------------------------------------------------------
    -- Test case [S00] Subtraction of two positive numbers.
    ----------------------------------------------------------------------------

    rs1_tb         <= "00000000000000000000000000001100";  --   12
    rs2_tb         <= "00000000000000000000000000000011";  -- -  3
    --                                                     -- -----
    expected_value <= "00000000000000000000000000001001";  --    9

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced subtraction of '12' and '3' be '9'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '0' report "Expect a Non-negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect not-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect no overflow" severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect no carry" severity error;
    ----------------------------------------------------------------------------
    -- Test case [S02] Subtraction of positive and negative numbers.
    ----------------------------------------------------------------------------

    rs1_tb         <= "11111111111111111111111111111101";  --   -3
    rs2_tb         <= "00000000000000000000000000000011";  -- -  3
    --                                                     -- -----
    expected_value <= "11111111111111111111111111111010";  --   -6

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced subtraction of '-3' and '3' be '-6' " severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '1' report "Expect a negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect non-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect no overflow" severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect no-carry" severity error;

    ----------------------------------------------------------------------------
    -- Test case [S03] Subtraction where the result is negative.
    ----------------------------------------------------------------------------

    rs1_tb         <= "11111111111111111111111111111101";  --   -3
    rs2_tb         <= "00000000000000000000000000000001";  -- -  1
    --                                                     -- -----
    expected_value <= "11111111111111111111111111111100";  --   -4

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced sum of '-3' and '1' be '-2'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '1' report "Expect a negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect non-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect no overflow" severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect no carry" severity error;
    ----------------------------------------------------------------------------
    -- Test case [S01] Check SIMM13 doesn't interfere when I = 0.
    -- Test case [S04] Overflow flag is correctly set.
    ----------------------------------------------------------------------------

    rs1_tb         <= "11111111111111111111111111111111";  --   0xFFFFFFFF
    rs2_tb         <= "10000000000000000000000000000000";  -- - 0x80000000
    --                                                     -- -------------
    expected_value <= "01111111111111111111111111111111";  --   0x7FFFFFFF

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced sum of '0xFFFFFFFF' and '0x80000000' be '0x7FFFFFFF'." severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '0' report "Expect a negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '1' report "Expect overflow" severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect no carry" severity error;

    ----------------------------------------------------------------------------
    -- Test case [S10] Check RS2 doesn't interfere when I = 1.
    ----------------------------------------------------------------------------

    -- Given a valid SUM instruction add its values
    instruction_tb <= "01" &            -- OP
                      "00000" &  -- RD (Ignored as windows are not implemented)
                      "010100" &        -- OP3 (Opcode of the instriction)
                      "00000" &         -- RS1
                      "1" &             -- I value
                      "0000000000011"   -- SIMM13
;

    rs1_tb         <= "00000000000000000000000000001100";  --   12
    rs2_tb         <= "00000000000000000000000000001111";  -- - 15 (RS2 IGNORED!)
    -- simm13         "00000000000000000000000000000011"   --    3
    --                                                     -- -----
    expected_value <= "00000000000000000000000000001001";  --    9

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced sum of '12' and '3' be '15'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '0' report "Expect a Non-negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect not-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect no overflow" severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect no carry" severity error;

    -- ----------------------------------------------------------------
    -- --------------------- MULTIPLICATION ---------------------------
    -- ----------------------------------------------------------------

    -- constant SMUL_OPCODE : std_logic_vector(5 downto 0) := "011011";
    -- constant UMUL_OPCODE : std_logic_vector(5 downto 0) := "011010";

    -- Given a valid SUM instruction add its values
    instruction_tb <= "01" &            -- OP
                      "00000" &  -- RD (Ignored as windows are not implemented)
                      "011011" &        -- OP3 (Opcode of the instriction)
                      "00000" &         --RS1
                      "0" &             -- I value
                      "00000000" &      -- ASI (UNUSED)
                      "00011"  -- RS2 (Ignored as windows are not implemented)
;


    -- icc_tb <=
    --   -- N indicates whether the 32-bit 2’s complement ALU result was negative
    --   -- for the last instruction that modified the icc field. 1 = negative, 0 =
    --   -- not negative.
    --   "0" &
    --   -- Z indicates whether the 32-bit ALU result was zero for the last
    --   -- instruction that modified the icc field. 1 = zero, 0 = nonzero.
    --   "0" &
    --   -- V indicates whether the ALU result was within the range of (was
    --   -- represent- able in) 32-bit 2’s complement notation for the last
    --   -- instruction that modified the icc field. 1 = overflow, 0 = no overflow.
    --   "0" &
    --   -- C indicates whether a 2’s complement carry out (or borrow) occurred for
    --   -- the last instruction that modified the icc field. Carry is set on
    --   -- subtraction if there is a carry out of bit 31. Carry is set on subtraction
    --   -- if there is borrow into bit 31. 1 = carry, 0 = no carry.
    --   "0";

    ----------------------------------------------------------------------------
    -- Test case [M00] Signed multiplication between two positive numbers.
    ----------------------------------------------------------------------------

    rs1_tb         <= "00000000000000000000000010111100";  --   188
    rs2_tb         <= "00000000000000000000000000101010";  -- *  42
    --                                                     -- -------------
    expected_value <= "00000000000000000001111011011000";  --  7896

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced multiplication of '188' and '42' be '7896'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '0' report "Expect a non-negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect non-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect zero." severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect zero." severity error;

    ----------------------------------------------------------------------------
    -- Test case [M01] Signed multiplication between two negative numbers.
    ----------------------------------------------------------------------------

    rs1_tb         <= "11111111111111111111111101000100";  --   -188
    rs2_tb         <= "11111111111111111111111111010110";  -- *  -42
    --                                                     -- -------------
    expected_value <= "00000000000000000001111011011000";  --   7896

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced multiplication of '188' and '42' be '7896'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '0' report "Expect a non-negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect non-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect zero." severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect zero." severity error;

    ----------------------------------------------------------------------------
    -- Test case [M02] Signed multiplication between a positive and a negative number.
    ----------------------------------------------------------------------------

    rs1_tb         <= "00000000000000000000000010111100";  --    188
    rs2_tb         <= "11111111111111111111111111010110";  -- *  -42
    --                                                     -- -------------
    expected_value <= "11111111111111111110000100101000";  --  -7896

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced multiplication of '188' and '42' be '7896'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '1' report "Expect a negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect non-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect zero." severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect zero." severity error;

    ----------------------------------------------------------------------------
    -- Test case [M03] Signed multiplication between a negative and a positive number.
    ----------------------------------------------------------------------------

    rs1_tb         <= "11111111111111111111111101000100";  --   -188
    rs2_tb         <= "00000000000000000000000000101010";  -- *   42
    --                                                     -- -------------
    expected_value <= "11111111111111111110000100101000";  --  -7896

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced multiplication of '188' and '42' be '7896'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '1' report "Expect a negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect non-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect zero." severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect zero." severity error;

    ----------------------------------------------------------------------------
    -- Test case [M04] Unsigned multiplication works properly.
    ----------------------------------------------------------------------------
    instruction_tb <= "01" &            -- OP
                      "00000" &  -- RD (Ignored as windows are not implemented)
                      "011010" &        -- OP3 (Opcode of the instriction)
                      "00000" &         --RS1
                      "0" &             -- I value
                      "00000000" &      -- ASI (UNUSED)
                      "00011"  -- RS2 (Ignored as windows are not implemented)
;

    rs1_tb         <= "00000000000000000000000010111100";  --   188
    rs2_tb         <= "00000000000000000000000000101010";  -- *  42
    --                                                     -- ------
    expected_value <= "00000000000000000001111011011000";  --  7896

    wait for 1 ns;

    -- RD
    assert rd_tb = expected_value report "Expeced multiplication of '188' and '42' be '7896'. Getted: " & integer'image(to_integer(unsigned(rd_tb))) severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '0' report "Expect a negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '0' report "Expect non-zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect zero." severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '0' report "Expect zero." severity error;

  end process stimulus_process;
 end;
