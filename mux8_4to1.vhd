-------------------------------------------------------
--! @file mux8_4to1.vhd
--! @brief 2-to-1 4-bit multiplexer
--! @author Walter Daniel Ventura (walter.ventura@usp.br)
--! @date 2021-03-15
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux8_4to1 is
    port 
    (
      SEL : in  std_logic_vector(1 downto 0);    
      A   : in  std_logic_vector(7 downto 0);
      B   : in  std_logic_vector(7 downto 0);
      C   : in  std_logic_vector(7 downto 0);
      D   : in  std_logic_vector(7 downto 0);
      Y   : out std_logic_vector(7 downto 0)
    );
end entity mux8_4to1;
  
architecture with_select of mux8_4to1 is
begin
      with SEL select
      Y <= A when "00",
            B when "01",
            C when "10",
            D when "11",
          "00000000" when others;
end architecture with_select;
  