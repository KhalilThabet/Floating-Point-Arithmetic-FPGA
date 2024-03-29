LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Testbench_full_adder IS
END Testbench_full_adder;

ARCHITECTURE behavior OF Testbench_full_adder IS


 component full_adder
 port (
     A: IN std_logic;
     B : IN std_logic;
     Cin : IN std_logic;
     sum : OUT std_logic;
     Cout : OUT std_logic
 );
end component;

 signal A : std_logic := '0';
 signal B : std_logic := '0';
 signal Cin : std_logic := '0';

 signal S : std_logic;
 signal Cout : std_logic;

begin

   uut: full_adder PORT MAP (
   A => A,
   B => B,
   Cin => Cin,
   sum => S,
   Cout => Cout
   );

   stim: process
   begin
   wait for 100 ns;

   A <= '1';
   B <= '0';
   Cin <= '0';
   wait for 10 ns;

   A <= '0';
   B <= '1';
   Cin <= '0';
   wait for 10 ns;

   A <= '1';
   B <= '1';
   Cin <= '0';
   wait for 10 ns;

   A <= '0';
   B <= '0';
   Cin <= '1';
   wait for 10 ns;

   A <= '1';
   B <= '0';
   Cin <= '1';
   wait for 10 ns;

   A <= '0';
   B <= '1';
   Cin <= '1';
   wait for 10 ns;

   A <= '1';
   B <= '1';
   Cin <= '1';
   wait for 10 ns;

  end process stim;
----------------------------------------
end behavior;
