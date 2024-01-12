library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAX_MIN is
    generic (N: INTEGER := 8);
    port(
        maxORmin : in  std_logic;
        A, B :     in  signed(N-1 downto 0);
        result :   out signed(N-1 downto 0));
end entity MAX_MIN;

-- Architecture Definition
architecture gate_level of MAX_MIN is

  component ADD_SUB
      generic(N: positive := 8);
      port(
         addORsub :   in std_logic;
         A :     in signed ((N-1) downto 0);
         B :     in signed ((N-1) downto 0);
         SUM :   out signed ((N-1) downto 0);
         Cout   : out std_logic);
  end component;

  signal tempSUM : signed(N-1 downto 0);
  signal carry : std_logic;
  begin
  ----------------------------------------
    stage_0 :  ADD_SUB  generic map(N)
      port map (addORsub => '1',A => A,B => B,SUM => tempSUM,Cout => carry); -- A-B

max_min : process(tempSUM, maxORmin)
      variable FLAGS : signed(5 downto 0) := "000000";
      begin
        FLAGS(0) := '1'; -- is A=B ?
        eachBit: for i in 0 to (N-1) loop
          FLAGS(0) := (FLAGS(0) AND (NOT tempSUM(i)));
        end loop;
        FLAGS(1) := NOT FLAGS(0); -- A!=B
        FLAGS(2) := NOT tempSUM(N-1);--A >= B if tempSUM(N-1)=0 then
        FLAGS(3) := FLAGS(2) AND FLAGS(1); -- A>B if A>=B & A!=B
        FLAGS(4) := NOT FLAGS(3);-- A<=B if !(A>B)
        FLAGS(5) := FLAGS(4) AND FLAGS(1); -- A<B if (A<=B & A!=B)
        if (((maxORmin = '0') AND (FLAGS(5) = '1')) OR ((maxORmin = '1') and (FLAGS(3) = '1'))) then
          result <= B;
        else
          result <= A;
        end if;
end process max_min;
----------------------------------------
end gate_level;