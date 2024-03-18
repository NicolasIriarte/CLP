library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sumNb_VIO is
	port(
		clk_i: 	in std_logic
	);
end;

architecture sumNb_VIO_arq of sumNb_VIO is
	-- Parte declarativa
	
	COMPONENT vio_0
	  PORT (
	    clk : IN STD_LOGIC;
	    probe_in0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	    probe_in1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	    probe_out0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	    probe_out1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	    probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
	  );
	END COMPONENT;
	
	signal probe_a	: std_logic_vector(3 downto 0);
	signal probe_b	: std_logic_vector(3 downto 0);
	signal probe_ci	: std_logic;
	signal probe_s	: std_logic_vector(3 downto 0);
	signal probe_co	: std_logic;

begin
	-- Parte descriptiva

	sumNb_inst: entity work.sumNb
		generic map(
			N => 4
		)
		port map(
			a_i		=> probe_a,
		    b_i		=> probe_b,
		    ci_i	=> probe_ci,
		    s_o		=> probe_s,
		    co_o	=> probe_co
		);
		
	VIO_inst : vio_0
		  PORT MAP (
		    clk			=> clk_i,
		    probe_in0	=> probe_s,
		    probe_in1(0)=> probe_co,
		    probe_out0	=> probe_a,
		    probe_out1	=> probe_b,
		    probe_out2(0)	=> probe_ci
		  );

	
end;