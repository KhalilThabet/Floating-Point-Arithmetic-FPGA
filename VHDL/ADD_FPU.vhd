library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity ADD_FPU is
    generic(N: integer := 32);
    Port(
		 OPP : in std_logic;
       A :     in signed((N-1) downto 0);
       B :     in signed((N-1) downto 0);
       SUM :   out signed((N-1) downto 0));
end ADD_FPU;

architecture fpu_arch of ADD_FPU is

component ADD_SUB
    generic(N: positive := 8);
    port(
       addORsub :  in std_logic;
       A :     in signed ((N-1) downto 0);
       B :     in signed ((N-1) downto 0);
       SUM :   out signed ((N-1) downto 0);
       Cout  :  out std_logic);
end component;
component Identification
    generic(N: positive := 8);
    port (
       SEL: in  std_logic;
       Y1 : in  signed (N-1 downto 0);
       Y2 : in  signed (N-1 downto 0);
       Out1  : out signed (N-1 downto 0);
       Out2 :  out signed (N-1 downto 0));
end component;

component shift_unit
    generic(N: integer := 8);
    port(
      dir :    in std_logic;
      A :      in signed(N-1 downto 0);
      B :      in signed(5 downto 0);
      result : out signed(N-1 downto 0));
end component;

component MUX_Nbits
    generic(N: positive := 8);
    port (
           SEL: in  std_logic;
           Y1 : in  signed (N-1 downto 0);
           Y2 : in  signed (N-1 downto 0);
           Y  : out signed (N-1 downto 0));
end component;

component MAX_MIN
    generic (N: INTEGER := 8);
    port(
        maxORmin : in  std_logic;
        A, B :     in  signed(N-1 downto 0);
        result :   out signed(N-1 downto 0));
end component;

component xor_gate
  port(
    a,b:in std_logic;
    c : out std_logic);
end component;

signal signA: std_logic;
signal signB: std_logic;
signal expA: signed(7 downto 0);
signal expB: signed(7 downto 0);
signal fractionA: signed(22 downto 0); -- original value
signal fractionB: signed(22 downto 0); -- original value

signal expDiff: signed(7 downto 0); -- exponentA - exponentB
signal maxExponent : signed(7 downto 0);
signal fractionL: signed(22 downto 0); -- First number fraction
signal fractionS: signed(24 downto 0); -- Second number fraction after alignment
signal intermediate_fractionS: signed(22 downto 0); -- Second number fraction before alignment
signal tempFraction_result : signed(24 downto 0); -- after 1 shift to the right if needed
signal tempFraction_result2 : signed(24 downto 0); -- after shift Correction
signal tempFraction_result3 : signed(24 downto 0); -- after add Correction
signal SUBorADD: std_logic;
signal carryFractions: std_logic;
signal temp2 : std_logic;
signal temp : std_logic;
signal tmp_exp : signed(7 downto 0);
signal s2 : signed(24 downto 0);
signal s1 : signed(24 downto 0);
signal s3 : signed(7 downto 0);
signal s4 : signed(5 downto 0);
signal s5 : signed(24 downto 0);
begin
----------------------------------------
    signA <= A(31);
    signB <= B(31);
    expA <= A(30 downto 23);
    expB <= B(30 downto 23);
    fractionA <= A(22 downto 0);
    fractionB <= B(22 downto 0);
	SUBorADD <= OPP xor A(31) xor B(31);
   --stage_1 : -- Negate the exponentB
		--	for i in 0 to 7 generate
			--	stage_i : xor_gate port map(expB(i),SUBorADD,tmp_exp(i));
			--end generate;
	stage_1 : ADD_SUB
              port map ('1', expA, expB, expDiff);
    -- Exponent identification : 
    stage_3 : Identification generic map (23)
              port map (expDiff(7), fractionA, fractionB, fractionL, intermediate_fractionS);
		
	 s2 <= '0' & '0' & intermediate_fractionS;
   -- fractionS <= (to_integer(unsigned(expDiff(5 downto 0))) downto 0)& s2(22 downto to_integer(unsigned(expDiff(5 downto 0)))-1);

    -- Exponent alligenment : shift right the fraction of the Number with the min exp
    stage_4 : shift_unit generic map(25)
              port map ('1',s2, expDiff(5 downto 0), fractionS);
	s1 <= '0' & '1' & fractionL;

    -- Add the fractions, save the carry and the temp result for the next step
    stage_5 : ADD_SUB generic map(25)
              port map (SUBorADD, s1, fractionS, tempFraction_result, carryFractions);

    -- verifying if the sum of the 1.fractionA + 1.fractionB >1 -> add 1 to Exponent
	s3 <= (7 downto 1 => '0') & tempFraction_result(24);
    stage_6 : ADD_SUB generic map(8)
                  port map ('0', maxExponent, s3, SUM(30 downto 23), temp);

    -- verifying if 1.fractionA + 1.fractionB > 1 -> shift right once the fraction result
	 s4 <= (5 downto 1 => '0') & tempFraction_result(24);
    stage_7 : shift_unit generic map(25)
              port map ('0', tempFraction_result, s4, tempFraction_result2);

    -- Correction to the fraction result
	 s5 <= (24 downto 1 => '0') & tempFraction_result(0);
    stage_8 :  ADD_SUB generic map(25)
                  port map ('0', tempFraction_result2, s5, tempFraction_result3, temp2);

	 stage_9 : MUX_Nbits generic map(8)
              port map (expDiff(7), expA, expB, maxExponent);
				  
SUM(22 downto 0) <= tempFraction_result3(22 downto 0);

    SUM(31) <=   ((tempFraction_result2(23) OR expDiff(7)) and (((not OPP) and signB) OR ((not signB) and OPP)))
                  OR ((not expDiff(7)) and (not tempFraction_result2(23)) and signA);
----------------------------------------
end fpu_arch;
