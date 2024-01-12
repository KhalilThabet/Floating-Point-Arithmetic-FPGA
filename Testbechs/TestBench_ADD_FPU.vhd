LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity Testbench_ADD_FPU is
end Testbench_ADD_FPU;

architecture behavior of Testbench_ADD_FPU is

 component ADD_FPU
     generic(N: integer := 32);
     Port(
        OPP : in std_logic;
        A :     in signed((N-1) downto 0);
        B :     in signed((N-1) downto 0);
        SUM :   out signed((N-1) downto 0));
 end component;

 signal OPP :  std_logic;
 signal A :    signed(31 downto 0);
 signal B :    signed(31 downto 0);
 signal SUM :  signed(31 downto 0);
 signal expected : signed(31 downto 0);

begin
----------------------------------------
  uut :  ADD_FPU
    port map (OPP,A,B,SUM);

  stim: process
  begin
    wait for 100 ns;
    OPP <= '0', '1' after 200 ns;
    A <= "01000011000000000000000000000000" , "01000000111000110011001100110011" after 50 ns ,"01000001000101100110011001100110" after 100 ns, "01000001000001000010100011110110" after 150 ns,"11000000101001100110011001100110" after 200 ns, "11000000110010110011001100110011" after 250 ns;
    B <= "01000001110000000000000000000000" , "11000001001100111010111000010100" after 50 ns ,"11000000010001100110011001100110" after 100 ns, "11000000111100110011001100110011" after 150 ns,"11000001010000001111010111000011" after 200 ns, "11000001000110110011001100110011" after 250 ns;
    expected <= "01000011000110000000000000000000","11000000100001000010100011110110" after 50 ns ,"01000000110010011001100110011010" after 100 ns, "01000001011111011100001010010000" after 150 ns,"11000001100010100001010001111011" after 200 ns, "11000001100000000110011001100110" after 250 ns;
    wait for 100 ns;
  end process stim;
----------------------------------------
end behavior;

--EndOfFile
