library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity xor_gate is
  port(
    a,b:in std_logic;
    c : out std_logic);
end xor_gate;


architecture gate_level of xor_gate is
  begin
  c<=a xor b;
end gate_level;