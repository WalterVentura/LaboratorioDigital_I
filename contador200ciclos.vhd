-------------------------------------------------------------------
-- Arquivo   : contador200ciclos.vhd
-- Projeto   : Jogo do Desafio da Memória
-------------------------------------------------------------------        
--  Autores:  Walter Daniel Ventura 
--            Antonio Pinheiro da Silva Júnior
--            Vinícius Bueno de Moraes
-------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador200ciclos is 
    port 
    (
        clock : in std_logic;
        clr   : in std_logic;
        ld    : in std_logic;
        ent   : in std_logic;
        enp   : in std_logic;
        D     : in std_logic_vector (7 downto 0);
        Q     : out std_logic_vector (7 downto 0);
        rco   : out std_logic
    );
end entity contador200ciclos;

architecture contador200ciclos_arch of contador200ciclos is

    signal IQ: integer range 0 to 199;

begin

    process (clock, clr, ld, ent, enp, IQ)
    begin

        if clock'event and clock = '1' then
            if clr = '0' then IQ <= 0;
            elsif ld = '0' then IQ <= to_integer(unsigned(D));
            elsif ent = '1' and enp = '1' then 
                if IQ = 199 then IQ <= 0;
                else IQ <= IQ + 1;
                end if;
            else IQ <= IQ;
            end if;
        end if;

        if IQ = 199 and ent = '1' then rco <= '1';
        else rco <= '0';
        end if;

        Q <= std_logic_vector(to_unsigned(IQ, Q'length));

    end process;

end architecture contador200ciclos_arch;