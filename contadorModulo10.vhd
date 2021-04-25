-------------------------------------------------------------------
-- Arquivo   : contadorModulo10.vhd
-- Projeto   : Projeto do Jogo do Desafio da Memória
-------------------------------------------------------------------        
--  Autores:  Walter Daniel Ventura 
--            Antonio Pinheiro da Silva Júnior
--            Vinícius Bueno de Moraes
-------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contadorModulo10 is
    port
    (
        clock : in std_logic;
        clr   : in std_logic;
        ent   : in std_logic;   
        enp   : in std_logic;
        Q     : out std_logic_vector(3 downto 0);
        rco   : out std_logic
    );
end entity contadorModulo10;

architecture contadorModulo10_arch of contadorModulo10 is

    signal IQ : integer range 0 to 9;

begin

    process (clock, clr, ent, enp, IQ)
    begin
        
        if clock'event and clock = '1' then
            if clr = '1' then 
                IQ <= 0;
            elsif ent = '1' and enp = '1' then 
                if IQ = 9 then 
                    IQ <= 0;
                else 
                    IQ <= IQ + 1;
                end if;
            else
                IQ <= IQ;
            end if;
        end if;

        if IQ = 9 and ent = '1' then rco <= '1';
        else                         rco <= '0';
        end if;

        Q <= std_logic_vector(to_unsigned(IQ, Q'length));

    end process;

end architecture contadorModulo10_arch;