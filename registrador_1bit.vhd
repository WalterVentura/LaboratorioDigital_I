------------------------------------------------------------------
-- Arquivo   : registrador_1bit.vhd
-- Projeto   : Jogo do Desafio da Memória
------------------------------------------------------------------
-- Descricao : registrador de 1 bit 
--             com clear assincrono e enable
------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     31/01/2020  1.0     Edson Midorikawa  criacao
--     13/03/2021  1.1     Walter Ventura    modificacao
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity registrador_1bit is
  port 
  (
    clock:  in  std_logic;
    clear:  in  std_logic;
    enable: in  std_logic;
    D:      in  std_logic;
    Q:      out std_logic
  );
end entity;

architecture arch of registrador_1bit is
  signal IQ: std_logic;
begin
    process(clock, clear, IQ)
    begin
      if (clear = '1') then IQ <= '0';
      elsif (clock'event and clock='1') then
        if (enable='1') then IQ <= D; end if;
      end if;
    end process;

    Q <= IQ;
end architecture;