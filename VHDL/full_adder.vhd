library ieee;
use ieee.std_logic_1164.all;


entity full_adder is
      Port (
          a : in std_logic; -- takes the i-th bit in the first value
          b : in std_logic; -- takes the i-th bit in the second value
          Cin : in std_logic; -- takes the carry of the previous addition
          sum : out std_logic; -- represents the i-th bit of the output value
          Cout : out std_logic -- takes the carry to the next addition
          );
end full_adder;


architecture fpu_arch of full_adder is
begin
     sum <= a XOR b XOR Cin ;
     Cout <= (a AND b) OR (Cin AND a) OR (Cin AND b) ;
end fpu_arch;
