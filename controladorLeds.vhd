-------------------------------------------------------------------
-- Arquivo   : controladorLeds.vhd
-- Projeto   : Projeto Base do Jogo do Desafio da Memória
-------------------------------------------------------------------        
--  Autores:  Walter Daniel Ventura 
--            Antonio Pinheiro da Silva Júnior
--            Vinícius Bueno de Moraes
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity controladorLeds is
    port 
    (
      estado      : in  std_logic_vector(4 downto 0);
      db_memoria  : in  std_logic_vector(3 downto 0);
      db_jogada   : in  std_logic_vector(3 downto 0);
      leds        : out std_logic_vector(3 downto 0)
    );
end entity controladorLeds;

architecture controladorLeds_arch  of controladorLeds is

begin

    with estado select
        leds <=            
            "0000"     when "00000", -- when INICIAL,
            "0000"     when "00001", -- when SELECIONA_JOGADORES,
            "0000"     when "00010", -- when SELECIONA_DIFICULDADE,
            "0000"     when "00011", -- when INICIALIZA_ELEMENTOS,
            "0000"     when "00100", -- when ESPERA_JOGADOR_1,
            "0000"     when "00101", -- when ESPERA_JOGADOR_2,
            "0000"     when "00110", -- when REGISTRA_JOGADA,
            db_jogada  when "00111", -- when DELAY_REGISTRO_HUMANO,
            "0000"     when "01000", -- when SELECIONA_JOGADA_MAQUINA,
            "0000"     when "01001", -- when REGISTRA_JOGADA_MAQUINA,
            db_jogada  when "01010", -- when DELAY_REGISTRO_MAQUINA,
            "0000"     when "01011", -- when ESCREVE_JOGADA_NA_MEMORIA,
            "0000"     when "01100", -- when COMPARA_JOGADA,
            "0000"     when "01101", -- when PONTUA_JOGADOR_1,
            "0000"     when "01110", -- when PONTUA_JOGADOR_2,
            "0000"     when "01111", -- when PASSA_PARA_PROXIMA_JOGADA,
            "0000"     when "10000", -- when PASSA_RODADA_E_AVANCA_ENDERECO,
            "0000"     when "10001", -- when PASSA_RODADA_SEM_AVANCAR_ENDERECO,
            "0000"     when "10010", -- when GANHOU, -- EMPATE
            "0000"     when "10011", -- when PERDEU,
            "0000"     when "10100", -- when SCORE_1,
            "0000"     when "10101", -- when SCORE_2,
            "0000"     when "10110", -- when SCORE_TOTAL,
            "0000"     when "10111", -- when INICIALIZA_REPETICAO,
            "0000"     when "11000", -- when INICIALIZA_REPETICAO_ULTIMA_RODADA,
            db_memoria when "11001", -- when ESPERA_REPETICAO,   
            "0000"     when "11010", -- when AVANCA_REPETICAO,
            "0000"     when "11011", -- when INICIALIZA_REPETICAO_MAQUINA,
            db_memoria when "11100", -- when ESPERA_REPETICAO_MAQUINA,
            "0000"     when "11101", -- when AVANCA_REPETICAO_MAQUINA,
            "0000"     when others;

end architecture controladorLeds_arch;