-------------------------------------------------------------------
-- Arquivo   : registrador.vhd
-- Projeto   : Jogo do Desafio da Memória
-------------------------------------------------------------------        
--  Autores:  Walter Daniel Ventura 
--            Antonio Pinheiro da Silva Júnior
--            Vinícius Bueno de Moraes
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity registrador is
  generic
  (
    data_width : integer := 1
  );
  port 
  (
    clock:  in  std_logic;
    clear:  in  std_logic;
    enable: in  std_logic;
    D:      in  std_logic_vector(data_width - 1 downto 0);
    Q:      out std_logic_vector(data_width - 1 downto 0)
  );
end entity registrador;

architecture registrador_arch of registrador is

  signal IQ: std_logic_vector(data_width-1 downto 0);

begin

    process(clock, clear, IQ)
    
    begin
      if (clear = '1') then 
        IQ <= (others => '0');
      elsif (clock'event and clock='1') then
        if (enable='1') then IQ <= D; end if;
      end if;

    end process;

    Q <= IQ;
end architecture registrador_arch;