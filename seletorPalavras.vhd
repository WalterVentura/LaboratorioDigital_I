-------------------------------------------------------
--! @file seletorPalavras.vhd
--! @brief 2-to-1 4-bit multiplexer
--! @author Walter Daniel Ventura (walter.ventura@usp.br)
--! @date 2021-03-15
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity seletorPalavras is
    port 
    (
      estado      : in  std_logic_vector(4 downto 0);
      modo        : in  std_logic;
      nivel       : in  std_logic_vector(1 downto 0);
      timeout     : in  std_logic_vector(20 downto 0);
      score1      : in  std_logic_vector(13 downto 0);
      score2      : in  std_logic_vector(13 downto 0);
      scoreTotal  : in  std_logic_vector(13 downto 0);
      saida       : out std_logic_vector(41 downto 0)
    );
end entity seletorPalavras;
  
  architecture with_select of seletorPalavras is

    signal regSaida : std_logic_vector(41 downto 0);

  begin
        process(estado, modo, nivel)
        begin
          case estado is 
 
            when "00000" => -- INICIAL
              regSaida <= "111100101010111101110010011111011110100011"; -- Início

            when "00001" => -- SELECIONA_JOGADORES
              if modo = '0' then
                regSaida <= "110000110000001000010001001011111111111001"; -- JOG__1
              else
                regSaida <= "110000110000001000010001001011111110100100"; -- JOG__2
              end if;

            when "00010" => -- SELECIONA_DIFICULDADE,
              if nivel = "00" then
                regSaida <= "010000111011110001110111111111111111111001"; -- diF__1
              elsif nivel = "01" then
                regSaida <= "010000111011110001110111111111111110100100"; -- diF__2
              elsif nivel = "10" then 
                regSaida <= "010000111011110001110111111111111110110000"; -- diF__3
              else
                regSaida <= "010000111011110001110111111111111110011001"; -- diF__4
              end if;

            when "00011" => -- INICIALIZA_ELEMENTOS,
              
            when "00100" => -- ESPERA_JOGADOR_1,
              regSaida(41 downto 35) <= "1100001"; -- J
              regSaida(34 downto 28) <= "1111001"; -- 1
              regSaida(27 downto 21) <= "1111111"; -- Vazio
              regSaida(20 downto 0) <= timeout;

            when "00101" => -- ESPERA_JOGADOR_2,
              regSaida(41 downto 35) <= "1100001"; -- J
              regSaida(34 downto 28) <= "0100100"; -- 2
              regSaida(27 downto 21) <= "1111111"; -- Vazio
              regSaida(20 downto 0) <= timeout;

            when "00110" => -- REGISTRA_JOGADA,

            when "00111" => -- DELAY_REGISTRO_HUMANO,
              --regSaida <= "111111111111111111111111111111111111111111"; -- vazio

            when "01000" => -- SELECIONA_JOGADA_MAQUINA,
              regSaida <= "000001110000000000111111111111111111111111"; -- bot__1

            when "01001" => -- REGISTRA_JOGADA_MAQUINA,
              regSaida <= "000001110000000000111111111111111111111111"; -- bot__2

            when "01010" => -- DELAY_REGISTRO_MAQUINA,
              regSaida <= "000001110000000000111111111111111111111111"; -- bot__3  

            when "01011" => -- ESCREVE_JOGADA_NA_MEMORIA,

            when "01100" => -- COMPARA_JOGADA,

            when "01101" => -- PONTUA_JOGADOR_1,

            when "01110" => -- PONTUA_JOGADOR_2,

            when "01111" => -- PASSA_PARA_PROXIMA_JOGADA,

            when "10000" => -- PASSA_RODADA_E_AVANCA_ENDERECO,

            when "10001" => -- PASSA_RODADA_SEM_AVANCAR_ENDERECO,

            when "10010" => -- GANHOU, -- EMPATE
              regSaida <= "100001001000000101011000101101000111100011"; -- Ganhou

            when "10011" => -- PERDEU,
              regSaida <= "000110000001100101111010000100001101100011"; -- Perdeu

            when "10100" => -- SCORE_1,
              regSaida(41 downto 35) <= "1100001"; -- J
              regSaida(34 downto 28) <= "1111001"; -- 1
              regSaida(27 downto 21) <= "1111111"; -- Vazio
              regSaida(20 downto 7) <= score1;
              regSaida(6 downto 0) <= "0001100"; -- P

            when "10101" => -- SCORE_2,
              regSaida(41 downto 35) <= "1100001"; -- J
              regSaida(34 downto 28) <= "0100100"; -- 2
              regSaida(27 downto 21) <= "1111111"; -- Vazio
              regSaida(20 downto 7) <= score2;
              regSaida(6 downto 0) <= "0001100"; -- P
            
            when "10110" => -- SCORE_TOTAL,
              regSaida(41 downto 28) <= scoreTotal; -- Score
              regSaida(27 downto 21) <= "1111111"; -- Vazio
              regSaida(20 downto 14) <= "0001100"; -- P
              regSaida(13 downto 7) <= "0000111"; -- t
              regSaida(6 downto 0) <= "0010010"; -- S

            when "10111" => -- INICIALIZA_REPETICAO,
              regSaida <= "010111100001100001100000011000001110000110"; -- repete

            when "11000" => -- INICIALIZA_REPETICAO_ULTIMA_RODADA,
              regSaida <= "010111100001100001100000011000001110000110"; -- repete

            when "11001" => -- ESPERA_REPETICAO,   
              regSaida <= "010111100001100001100000011000001110000110"; -- repete

            when "11010" => -- AVANCA_REPETICAO,
              regSaida <= "010111100001100001100000011000001110000110"; -- repete

            when "11011" => -- INICIALIZA_REPETICAO_MAQUINA,
              regSaida <= "000001110000000000111111111111111111111111"; -- bot__4

            when "11100" => -- ESPERA_REPETICAO_MAQUINA,
              regSaida <= "000001110000000000111111111111111111111111"; -- bot__5

            when "11101" => -- AVANCA_REPETICAO_MAQUINA,
              regSaida <= "000001110000000000111111111111111111111111"; -- bot__6
              
            when others =>
              regSaida <= "111111111111111111111111111111111111111111";
          end case;
        end process;

        saida <= regSaida;
    
  end architecture with_select;
