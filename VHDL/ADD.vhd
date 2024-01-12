
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity ADD is
    generic(N: integer := 8);
    Port(
       Cin :   in std_logic; -- carry input initialized to 0
       A :     in signed((N-1) downto 0); -- the input vector A
       B :     in signed((N-1) downto 0); -- the input vector B
       SUM :   out signed((N-1) downto 0); -- output vector which represent A+B
       Cout : out std_logic -- ouput carry after the operation
    );
end ADD;

architecture arch of ADD is
component full_adder port (
          a :    in std_logic;
          b :    in std_logic;
          Cin :  in std_logic;
          sum :  out std_logic;
          Cout : out std_logic
          );
end component;

signal tmp : std_logic_vector (N downto 0);
begin
----------------------------------------
    tmp(0) <= Cin; -- initialized to the first Cin = 0

    Array_Of_full_adders: for i in 0 to (N-1) generate
        stage_i : full_adder port map (A(i) , B(i) , tmp(i), SUM(i), tmp(i+1));
    end generate;

    Cout <= tmp(N);
----------------------------------------
end arch;

