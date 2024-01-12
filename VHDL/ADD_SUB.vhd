library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ADD_SUB is
    generic(N: positive := 8); 
    port(
       addORsub :   in std_logic;
       A :     in signed ((N-1) downto 0);
       B :     in signed ((N-1) downto 0);
       SUM :   out signed ((N-1) downto 0);
       Cout  :  out std_logic);
end ADD_SUB;

architecture gate_level of ADD_SUB is

component ADD
  generic (N : positive := 8 );
  Port(
     Cin :   in std_logic;
     A :     in signed((N-1) downto 0);
     B :     in signed((N-1) downto 0);
     SUM :   out signed((N-1) downto 0);
     Cout : out std_logic);
end component;

component xor_gate
  port(
    a,b:in std_logic;
    c : out std_logic);
end component;

signal B_2 : signed (N-1 downto 0);
begin
----------------------------------------

  stage_0 : for i in 0 to N-1 generate
		            stage_i : xor_gate port map(B(i),addORsub,B_2(i));
            end generate;

  stage_1 :  ADD  generic map(N)
    port map (Cin => addORsub,A => A,B => B_2,SUM => SUM,Cout => Cout); -- A+B or A-B
  --  stage_0 : process(B,tmp)
 -- begin
--		for i in 0 to N-1 loop
--				
--				if B(i) = '0' and tmp = '0' then
--					tmp <= not tmp;
--					B_2(i) <= B(i) xor '0';
--				else
--				
--					B_2(i) <= B(i) xor '1';
--					
--				end if;
--				
--		end loop;
  --end process;
----------------------------------------
end gate_level;

--EndOfFile
