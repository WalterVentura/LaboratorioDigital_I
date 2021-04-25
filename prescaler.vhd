-------------------------------------------------------------------
-- Arquivo   : contador1000ciclos.vhd
-- Projeto   : Jogo do Desafio da Memória
-------------------------------------------------------------------        
--  Autores:  Walter Daniel Ventura 
--            Antonio Pinheiro da Silva Júnior
--            Vinícius Bueno de Moraes
-------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity prescaler is 
    port 
    (
        clock : in std_logic;
		reset : in std_logic;
        Q     : out std_logic
    );
end entity prescaler;

architecture prescaler_arch of prescaler is

    signal IQ: integer range 0 to 25001;
	signal s_q: std_logic;

begin

    process (clock, reset, IQ)
    begin

        if (reset = '1') then
		      s_q <= '0';
		  elsif clock'event and clock = '1' then
            if IQ < 25000 then
			   	IQ <= IQ + 1;
            else
				   IQ <= 0;
					s_q <= not(s_q);
            end if;
        end if;

    end process;

    Q <= s_q;
    
end architecture prescaler_arch;