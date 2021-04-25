-------------------------------------------------------------------

-- Arquivo   : unidade_controle.vhd
-- Projeto   : Projeto Base do Jogo do Desafio da Memória
-------------------------------------------------------------------        
--  Autores:  Walter Daniel Ventura 
--            Antonio Pinheiro da Silva Júnior
--            Vinícius Bueno de Moraes
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is 
    port 
    ( 
        clock                : in  std_logic; 
        reset                : in  std_logic; 
        jogar                : in  std_logic;
        enderecoDeEscrita    : in  std_logic;
        enderecoFimDeJogo    : in  std_logic;
        jogada               : in  std_logic;
        igual                : in  std_logic;
        timeout              : in  std_logic;
        repete               : in  std_logic;
        repeteTimeout        : in  std_logic;
        displaysTimeout      : in  std_logic;
        delayTimeout         : in  std_logic;
        modo                 : in  std_logic;
        zeraL                : out std_logic;
        zeraE                : out std_logic;
        contaLMais           : out std_logic;
        contaLmenos          : out std_logic;
        contaE               : out std_logic;
        registra             : out std_logic;
        escreve              : out std_logic;
        zeraTimeout          : out std_logic;
        zeraTimeoutRepeticao : out std_logic;
        zeraTimeoutDisplays  : out std_logic;
        zeraTimeoutDelay     : out std_logic;
        seletorMuxBot        : out std_logic;
        enable_score_1       : out std_logic;
        enable_score_2       : out std_logic;
        enable_score_total   : out std_logic;
        clear_score_1        : out std_logic;
        clear_score_2        : out std_logic;
        clear_score_total    : out std_logic;
        db_estado            : out std_logic_vector(4 downto 0)
    );
end entity;

architecture unidade_controle_arch of unidade_controle is

    type t_estado is
    (
        INICIAL,
        SELECIONA_JOGADORES,
        SELECIONA_DIFICULDADE,
        INICIALIZA_ELEMENTOS,
        ESPERA_JOGADOR_1,
        ESPERA_JOGADOR_2,
        REGISTRA_JOGADA,
        DELAY_REGISTRO_HUMANO,
        SELECIONA_JOGADA_MAQUINA,
        REGISTRA_JOGADA_MAQUINA,
        DELAY_REGISTRO_MAQUINA,
        ESCREVE_JOGADA_NA_MEMORIA,
        COMPARA_JOGADA,
        PONTUA_JOGADOR_1,
        PONTUA_JOGADOR_2,
        PASSA_PARA_PROXIMA_JOGADA,
        PASSA_RODADA_E_AVANCA_ENDERECO,
        PASSA_RODADA_SEM_AVANCAR_ENDERECO,
        GANHOU, -- EMPATE
        PERDEU,
        SCORE_1,
        SCORE_2,
        SCORE_TOTAL,
        INICIALIZA_REPETICAO,
		INICIALIZA_REPETICAO_ULTIMA_RODADA,
        ESPERA_REPETICAO,   
        AVANCA_REPETICAO,
        INICIALIZA_REPETICAO_MAQUINA,
        ESPERA_REPETICAO_MAQUINA,
        AVANCA_REPETICAO_MAQUINA
    );

    signal Eatual, Eprox : t_estado;
    signal regJogador : std_logic; --Registra de qual jogador é a vez
    signal regUltimaRodada : std_logic; 
    signal regJaRepetiu : std_logic; 

    signal tipo_vitoria : integer range 0 to 3; 
    -- 0 Venceu Da Maquina
    -- 1 Perdeu Da Maquina
    -- 2 Empatou(nenhum jogador cometeu erros)
    -- 3 Um jogador cometeu erro.
    
begin

    --mudanca de estado 
    process(clock, reset)
    begin
        if reset = '1' then 
            Eatual <= INICIAL;
        elsif clock'event and clock = '1' then 
            Eatual <= Eprox;
        end if;
    end process;
    
    --logica de proximo estado
    process(jogar, jogada, igual, Eatual, regJogador, regUltimaRodada, regJaRepetiu)
    begin
        case Eatual is

            when INICIAL =>

                if jogar = '0' then
                    Eprox <= INICIAL;
                else 
                    Eprox <= SELECIONA_JOGADORES;
                end if;

            when SELECIONA_JOGADORES =>

                if jogar = '0' then
                    Eprox <= SELECIONA_JOGADORES;
                else
                    Eprox <= SELECIONA_DIFICULDADE;
                end if;

            when SELECIONA_DIFICULDADE =>

                if jogar = '0' then
                    Eprox <= SELECIONA_DIFICULDADE;
                else
                    Eprox <= INICIALIZA_ELEMENTOS;
                end if;

            when INICIALIZA_ELEMENTOS =>

                regJaRepetiu <= '0';
                regUltimaRodada <= '0';

                if modo = '0' then
                    Eprox <= SELECIONA_JOGADA_MAQUINA;
                else
                    Eprox <= ESPERA_JOGADOR_1;
                end if;

            when ESPERA_JOGADOR_1 =>
                regJogador <= '0';

                if timeout = '0' then
                    if jogada = '0' then
                        Eprox <= ESPERA_JOGADOR_1;
                    else
                        Eprox <= REGISTRA_JOGADA;
                    end if;
                else
                    if modo = '0' then
                        tipo_vitoria <= 1;
                    else 
                        tipo_vitoria <= 3;
                    end if;  
                    Eprox <= PERDEU; 
                end if;

            when ESPERA_JOGADOR_2 =>
                regJogador <= '1';

                if timeout = '0' then
                    if jogada = '0' then
                        Eprox <= ESPERA_JOGADOR_2;
                    else
                        Eprox <= REGISTRA_JOGADA;
                    end if;
                else
                    tipo_vitoria <= 3;
                    Eprox <= PERDEU;    
                end if;

            when REGISTRA_JOGADA =>
                Eprox <= DELAY_REGISTRO_HUMANO;

            when DELAY_REGISTRO_HUMANO =>
                if delayTimeout = '0' then
                    Eprox <= DELAY_REGISTRO_HUMANO;
                else
                    if (modo = '1' and (enderecoDeEscrita = '0' or regUltimaRodada = '1')) or modo = '0' then
                        Eprox <= COMPARA_JOGADA;      
                    else
                        Eprox <= ESCREVE_JOGADA_NA_MEMORIA;
                    end if;
                end if;
            

            when SELECIONA_JOGADA_MAQUINA =>
                regJogador <= '1';
                Eprox <= REGISTRA_JOGADA_MAQUINA;

            when REGISTRA_JOGADA_MAQUINA =>
                Eprox <= DELAY_REGISTRO_MAQUINA;

            when DELAY_REGISTRO_MAQUINA =>
                if repeteTimeout = '0' then
                    Eprox <= DELAY_REGISTRO_MAQUINA;
                else
                    Eprox <= ESCREVE_JOGADA_NA_MEMORIA;
                end if;
					 
            when ESCREVE_JOGADA_NA_MEMORIA =>
                if modo = '1' then    
                    if regJogador = '0' then
                        EProx <= PONTUA_JOGADOR_1;
                    else
                        Eprox <= PONTUA_JOGADOR_2;
                    end if;
                else 
                    Eprox <= PASSA_RODADA_SEM_AVANCAR_ENDERECO;
                end if;

            when COMPARA_JOGADA =>
                if igual = '1' then
                    if enderecoDeEscrita = '0' then
                        Eprox <= PASSA_PARA_PROXIMA_JOGADA;
                    else
                        if modo = '0' then
                            Eprox <= PONTUA_JOGADOR_1;
                        else
                            tipo_vitoria <= 2;
                            Eprox <= GANHOU;
                        end if;
                    end if;
                else
                    if modo = '0' then
                        tipo_vitoria <= 1;
                    else
                        tipo_vitoria <= 3;
                    end if;
                    Eprox <= PERDEU;
                end if;
            
            when PONTUA_JOGADOR_1 =>
            if modo = '0' then
                if enderecoFimDeJogo = '1'then
                    tipo_vitoria <= 0;
                    Eprox <= GANHOU;
                else
                    Eprox <= PASSA_RODADA_E_AVANCA_ENDERECO;
                        end if;
            else
                if enderecoFimDeJogo = '0' then
                    if (modo = '1' or regJogador = '0') then
                        Eprox <= PASSA_RODADA_E_AVANCA_ENDERECO; 
                    else
                        Eprox <= PASSA_RODADA_SEM_AVANCAR_ENDERECO; 
                    end if;
                else
                    regUltimaRodada <= '1';
                    Eprox <= PASSA_RODADA_SEM_AVANCAR_ENDERECO; 
                end if;
            end if;

            when PONTUA_JOGADOR_2 =>
                if enderecoFimDeJogo = '0' then
                    if (modo = '1' or regJogador = '0') then
                        Eprox <= PASSA_RODADA_E_AVANCA_ENDERECO; 
                    else
                        Eprox <= PASSA_RODADA_SEM_AVANCAR_ENDERECO; 
                    end if;
                else
                    regUltimaRodada <= '1';
                    Eprox <= PASSA_RODADA_SEM_AVANCAR_ENDERECO; 
                end if;
            
					 
            when PASSA_PARA_PROXIMA_JOGADA =>
                if regJogador = '0' then
                    if enderecoDeEscrita = '0' then
                        Eprox <= ESPERA_JOGADOR_1;
                    else
                        Eprox <= ESPERA_JOGADOR_2;
					end if;
                else
                    if enderecoDeEscrita = '0' then
                        Eprox <= ESPERA_JOGADOR_2;
                    else
                        Eprox <= ESPERA_JOGADOR_1;
						end if;
                end if;
					 
            when PASSA_RODADA_E_AVANCA_ENDERECO =>
                if regJogador = '0' then
                    if modo = '0' then
                        Eprox <= INICIALIZA_REPETICAO_MAQUINA;
                    else
                        Eprox <= ESPERA_JOGADOR_2;
                    end if;
                else
                    Eprox <= ESPERA_JOGADOR_1;
                end if;

            when PASSA_RODADA_SEM_AVANCAR_ENDERECO =>
            if modo = '1' then
                if regJogador = '1' then
                    Eprox <= ESPERA_JOGADOR_1;
                else 
                    Eprox <= ESPERA_JOGADOR_2;
                end if;
            else
                if regJogador = '0' then
                    Eprox <= INICIALIZA_REPETICAO_MAQUINA;
                else
                    Eprox <= ESPERA_JOGADOR_1;
                end if;
            end if;

            when GANHOU =>
                if displaysTimeout = '0' then
                    if jogar = '1' then
                        Eprox <= INICIAL;
                    else
                        if repete = '1' then
                            Eprox <= INICIALIZA_REPETICAO_ULTIMA_RODADA;
                        else
                            Eprox <= GANHOU;
                        end if;
                    end if;
                else
                    if tipo_vitoria = 0 then
                        Eprox <= SCORE_1;
                    else 
                        Eprox <= SCORE_TOTAL;
                    end if;
                end if;
                                        

            when PERDEU =>
                if displaysTimeout = '0' then
                    if jogar = '1' then
                        Eprox <= INICIAL;
                    else
                        if repete = '1' then
                                    if regUltimaRodada = '0' and regJaRepetiu = '0' then
                                        Eprox <= INICIALIZA_REPETICAO;
                                    else
                                        Eprox <= INICIALIZA_REPETICAO_ULTIMA_RODADA;
                                    end if;
                        else
                            Eprox <= PERDEU;
                        end if;
                    end if;
                else
                    Eprox <= SCORE_1;
                end if;

            when SCORE_1 =>
            if displaysTimeout = '0' then
                if jogar = '1' then
                    Eprox <= INICIAL;
                else
                    if repete = '1' then
                                if regUltimaRodada = '0' and regJaRepetiu = '0' and 
                                   (tipo_vitoria = 1 or tipo_vitoria = 3) then
                                    Eprox <= INICIALIZA_REPETICAO;
                                else
                                    Eprox <= INICIALIZA_REPETICAO_ULTIMA_RODADA;
                                end if;
                    else
                        Eprox <= SCORE_1;
                    end if;
                end if;
            else
                if tipo_vitoria = 0 then
                    Eprox <= GANHOU;
                elsif tipo_vitoria = 1 then
                    Eprox <= PERDEU;
                else 
                    Eprox <= SCORE_2;
                end if;
            end if;

            when SCORE_2 =>
            if displaysTimeout = '0' then
                if jogar = '1' then
                    Eprox <= INICIAL;
                else
                    if repete = '1' then
                                if regUltimaRodada = '0' and regJaRepetiu = '0' then
                                    Eprox <= INICIALIZA_REPETICAO;
                                else
                                    Eprox <= INICIALIZA_REPETICAO_ULTIMA_RODADA;
                                end if;
                    else
                        Eprox <= SCORE_2;
                    end if;
                end if;
            else
                Eprox <= SCORE_1;
            end if;

            when SCORE_TOTAL =>
            if displaysTimeout = '0' then
                if jogar = '1' then
                    Eprox <= INICIAL;
                else
                    if repete = '1' then                    
                        Eprox <= INICIALIZA_REPETICAO_ULTIMA_RODADA;                                
                    else
                        Eprox <= SCORE_TOTAL;
                    end if;
                end if;
            else
                Eprox <= GANHOU;
            end if;

            when INICIALIZA_REPETICAO =>
                regJaRepetiu <= '1';
                Eprox <= ESPERA_REPETICAO;
					 
			when INICIALIZA_REPETICAO_ULTIMA_RODADA =>
					 Eprox <= ESPERA_REPETICAO;

            when ESPERA_REPETICAO =>
                if repeteTimeout = '0' then
                    Eprox <= ESPERA_REPETICAO;
                else
                    if enderecoDeEscrita = '0' then
                        Eprox <= AVANCA_REPETICAO;
                    else
                        if tipo_vitoria = 0 or tipo_vitoria = 2 then
                            Eprox <= GANHOU;
                        else
                            Eprox <= PERDEU;
                        end if;
                    end if;
                end if;

            when AVANCA_REPETICAO =>
                Eprox <= ESPERA_REPETICAO;

            when INICIALIZA_REPETICAO_MAQUINA =>
                Eprox <= ESPERA_REPETICAO_MAQUINA;

            when ESPERA_REPETICAO_MAQUINA =>
                if enderecoDeEscrita = '0' then
                    if repeteTimeout = '0' then 
                        Eprox <= ESPERA_REPETICAO_MAQUINA;
                    else
                        Eprox <= AVANCA_REPETICAO_MAQUINA;
                    end if;
                else
                    Eprox <= SELECIONA_JOGADA_MAQUINA;
                end if;
                

            when AVANCA_REPETICAO_MAQUINA =>
                Eprox <= ESPERA_REPETICAO_MAQUINA;
                

        end case;
    end process;

    -- sinais de controle
    with Eatual select
        zeraL <= '1' when INICIALIZA_ELEMENTOS,
                 '0' when others;

    with Eatual select
        zeraE <= '1' when INICIALIZA_ELEMENTOS | PASSA_RODADA_E_AVANCA_ENDERECO |
		                  PASSA_RODADA_SEM_AVANCAR_ENDERECO | INICIALIZA_REPETICAO |
                          INICIALIZA_REPETICAO_ULTIMA_RODADA |
                          INICIALIZA_REPETICAO_MAQUINA,
                 '0' when others;
        
    with Eatual select
        contaLMais <= '1' when PASSA_RODADA_E_AVANCA_ENDERECO,
                      '0' when others;

    with Eatual select
        contaLMenos <= '1' when INICIALIZA_REPETICAO,
                       '0' when others;             

    with Eatual select
        contaE <= '1' when PASSA_PARA_PROXIMA_JOGADA |
                           AVANCA_REPETICAO | 
                           AVANCA_REPETICAO_MAQUINA,
                  '0' when others;

    with Eatual select
        registra <= '1' when REGISTRA_JOGADA |
                             REGISTRA_JOGADA_MAQUINA,
                    '0' when others;

    with Eatual select
        escreve <= '1' when ESCREVE_JOGADA_NA_MEMORIA,
                   '0' when others;

    with Eatual select
        zeraTimeout <= '1' when INICIALIZA_ELEMENTOS | PASSA_PARA_PROXIMA_JOGADA |
                                PASSA_RODADA_E_AVANCA_ENDERECO | PASSA_RODADA_SEM_AVANCAR_ENDERECO,
                       '0' when others;

    with Eatual select
        zeraTimeoutRepeticao <= '1' when INICIALIZA_REPETICAO |
										 INICIALIZA_REPETICAO_ULTIMA_RODADA |
										 AVANCA_REPETICAO |
                                         INICIALIZA_REPETICAO_MAQUINA |
                                         AVANCA_REPETICAO_MAQUINA |
                                         REGISTRA_JOGADA_MAQUINA,
                                '0' when others;

    with Eatual select
        zeraTimeoutDisplays <= '1' when ESPERA_JOGADOR_1 |
                                        ESPERA_JOGADOR_2 |
                                        COMPARA_JOGADA,
                               '0' when others;

    with Eatual select
    zeraTimeoutDelay <= '1' when REGISTRA_JOGADA,
                            '0' when others;   
                                                
    with Eatual select
        seletorMuxBot <= '1' when SELECIONA_JOGADA_MAQUINA |
                                  REGISTRA_JOGADA_MAQUINA,
                         '0' when others;

    with Eatual select
        enable_score_1 <= '1' when PONTUA_JOGADOR_1,
                          '0' when others;
        
    with Eatual select
        enable_score_2 <= '1' when PONTUA_JOGADOR_2,
                          '0' when others;
    
    with Eatual select
        enable_score_total <= '1' when PONTUA_JOGADOR_1 |
                                       PONTUA_JOGADOR_2,
                              '0' when others;
                   
    with Eatual select
        clear_score_1 <= '1' when INICIALIZA_ELEMENTOS,
                         '0' when others;
        
    with Eatual select
        clear_score_2 <= '1' when INICIALIZA_ELEMENTOS,
                         '0' when others;
    
    with Eatual select
        clear_score_total <= '1' when INICIALIZA_ELEMENTOS,
                             '0' when others;        
                   
                   
    -- sinais de depuracao
    with Eatual select
        db_estado <= 
            "00000" when INICIAL,
            "00001" when SELECIONA_JOGADORES,
            "00010" when SELECIONA_DIFICULDADE,
            "00011" when INICIALIZA_ELEMENTOS,
            "00100" when ESPERA_JOGADOR_1,
            "00101" when ESPERA_JOGADOR_2,
            "00110" when REGISTRA_JOGADA,
            "00111" when DELAY_REGISTRO_HUMANO,
            "01000" when SELECIONA_JOGADA_MAQUINA,
            "01001" when REGISTRA_JOGADA_MAQUINA,
            "01010" when DELAY_REGISTRO_MAQUINA,
            "01011" when ESCREVE_JOGADA_NA_MEMORIA,
            "01100" when COMPARA_JOGADA,
            "01101" when PONTUA_JOGADOR_1,
            "01110" when PONTUA_JOGADOR_2,
            "01111" when PASSA_PARA_PROXIMA_JOGADA,
            "10000" when PASSA_RODADA_E_AVANCA_ENDERECO,
            "10001" when PASSA_RODADA_SEM_AVANCAR_ENDERECO,
            "10010" when GANHOU, -- EMPATE
            "10011" when PERDEU,
            "10100" when SCORE_1,
            "10101" when SCORE_2,
            "10110" when SCORE_TOTAL,
            "10111" when INICIALIZA_REPETICAO,
            "11000" when INICIALIZA_REPETICAO_ULTIMA_RODADA,
            "11001" when ESPERA_REPETICAO,   
            "11010" when AVANCA_REPETICAO,
            "11011" when INICIALIZA_REPETICAO_MAQUINA,
            "11100" when ESPERA_REPETICAO_MAQUINA,
            "11101" when AVANCA_REPETICAO_MAQUINA,
            "11111" when others;

end architecture unidade_controle_arch;