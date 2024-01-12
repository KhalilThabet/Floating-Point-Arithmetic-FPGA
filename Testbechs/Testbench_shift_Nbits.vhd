LIBRARY ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.ALL;

ENTITY Testbench_shift_Nbits IS
END Testbench_shift_Nbits;

ARCHITECTURE behavior OF Testbench_shift_Nbits IS


 component shift_Nbits
 generic(N: integer := 8); 
 port (
   dir :    in std_logic;
   enable : in std_logic;
   A :      in signed(N-1 downto 0);
   Aout :   out signed(N-1 downto 0));
end component;

 constant N : integer := 8;
 signal A : signed(N-1 downto 0) ;
 signal dir : std_logic := '1';
 signal enable : std_logic := '1';
 signal Aout : signed(N-1 downto 0);
begin
----------------------------------------
   uut: shift_Nbits PORT MAP (dir, enable, A, Aout);

   stim: process
   begin
     wait for 100 ns;
     A <= "10010010", "00010101" after 50 ns, "00001100" after 100 ns,"00001111" after 150 ns;
     wait for 50 ns;
  end process stim;
----------------------------------------
end behavior;
