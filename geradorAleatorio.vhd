-------------------------------------------------------------------
-- Arquivo   : geradorAleatorio.vhd
-- Projeto   : Jogo do Desafio da Memória
-------------------------------------------------------------------        
--  Autores:  Walter Daniel Ventura 
--            Antonio Pinheiro da Silva Júnior
--            Vinícius Bueno de Moraes
-------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity geradorAleatorio is 
    port 
    (
        clock     : in std_logic;
        aleatorio : out std_logic_vector (3 downto 0)
    );
end entity geradorAleatorio;

architecture geradorAleatorio_arch of geradorAleatorio is

    signal IQ: integer range 0 to 3;
begin

    process (clock, IQ)
    begin

        if clock'event and clock = '1' then
            if IQ = 3 then
                IQ <= 0;
            else 
                IQ <= IQ + 1;
            end if;
        end if;

        --cont_4bits <= std_logic_vector(to_unsigned(IQ, cont_4bits'length));
    end process;

    with IQ select
        aleatorio <= "0001" when 0,
             "0010" when 1,
             "0100" when 2,
             "1000" when 3,
             "1111" when others;

end architecture geradorAleatorio_arch;