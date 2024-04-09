library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu_tb is
end;

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

    -- Given a valid SUM instruction add its values
    instruction_tb <= "01" &            -- OP
                      "00000" &  -- RD (Ignored as windows are not implemented)
                      "010000" &        -- OP3 (Opcode of the instriction)
                      "00000" &         --RS1
                      "0" &             -- I value
                      "00000000" &      -- ASI (UNUSED)
                      "00000"  -- RS2 (Ignored as windows are not implemented)
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
    rs1_tb         <= "11111111111111111111111111111101";  --   -3
    rs2_tb         <= "00000000000000000000000000000011";  -- +  3
    --                                                     -- -----
    expected_value <= "00000000000000000000000000000000";  --    0

    wait for 1 ns;
    -- RD
    assert rd_tb = expected_value report "Expeced sum of '-3' and '3' be '0' " severity error;
    -- N -> 1 = negative, 0 = not negative
    assert icc_tb(3) = '0' report "Expect a Non-negative number" severity error;
    -- Z -> 1 = zero, 0 = nonzero
    assert icc_tb(2) = '1' report "Expect zero result" severity error;
    -- V -> 1 = overflow, 0 = no overflow
    assert icc_tb(1) = '0' report "Expect no overflow" severity error;
    -- C -> 1 = carry, 0 = no carry
    assert icc_tb(0) = '1' report "Expect carry" severity error;

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




  end process stimulus_process;
end;
