-------------------------------------------------------------------
-- Arquivo   : scoreCounter.vhd
-- Projeto   : Projeto do Jogo do Desafio da Memória
-------------------------------------------------------------------        
--  Autores:  Walter Daniel Ventura 
--            Antonio Pinheiro da Silva Júnior
--            Vinícius Bueno de Moraes
-------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity scoreCounter is
    port
    (
        clock              : in std_logic;
        enable_score_1     : in std_logic;
        enable_score_2     : in std_logic;
        enable_score_total : in std_logic;
        clear_score_1      : in std_logic;
        clear_score_2      : in std_logic;
        clear_score_total  : in std_logic;
        score_1            : out std_logic_vector(13 downto 0);
        score_2            : out std_logic_vector(13 downto 0);
        score_total        : out std_logic_vector(13 downto 0)
    );
end entity scoreCounter;

architecture scoreCounter_arch of scoreCounter is

    component contadorModulo10 is
        port
        (
            clock : in std_logic;
            clr   : in std_logic;
            ent   : in std_logic;   
            enp   : in std_logic;
            Q     : out std_logic_vector(3 downto 0);
            rco   : out std_logic
        );
    end component contadorModulo10;

    component hexa7seg is
        port 
        (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component hexa7seg;


    signal s_score1_unidade : std_logic_vector( 3 downto 0);
    signal s_score1_unidade_sseg : std_logic_vector(6 downto 0);
    signal s_score1_dezena : std_logic_vector( 3 downto 0);
    signal s_score1_dezena_sseg : std_logic_vector(6 downto 0);
    signal s_rco_score1 : std_logic;

    signal s_score2_unidade : std_logic_vector( 3 downto 0);
    signal s_score2_unidade_sseg : std_logic_vector(6 downto 0);
    signal s_score2_dezena : std_logic_vector( 3 downto 0);
    signal s_score2_dezena_sseg : std_logic_vector(6 downto 0);
    signal s_rco_score2 : std_logic;

    signal s_scoreTotal_unidade : std_logic_vector( 3 downto 0);
    signal s_scoreTotal_unidade_sseg : std_logic_vector(6 downto 0);
    signal s_scoreTotal_dezena : std_logic_vector( 3 downto 0);
    signal s_scoreTotal_dezena_sseg : std_logic_vector(6 downto 0);
    signal s_rco_scoreTotal : std_logic;
    

begin

    contUnidade_score_1 : contadorModulo10
    port map
    (
        clock => clock,
        clr => clear_score_1,
        ent => '1',
        enp => enable_score_1,
        Q => s_score1_unidade,
        rco => s_rco_score1
    );

    contDezena_score_1 : contadorModulo10
    port map
    (
        clock => clock,
        clr => clear_score_1,
        ent => s_rco_score1,
        enp => enable_score_1,
        Q => s_score1_dezena
    );

    HEX_unidade_score1 : hexa7seg
    port map
    (
        hexa =>s_score1_unidade,
        sseg =>s_score1_unidade_sseg
    );

    HEX_dezena_score1 : hexa7seg
    port map
    (
        hexa =>s_score1_dezena,
        sseg =>s_score1_dezena_sseg
    );


    -- SCORE 2
    contUnidade_score_2 : contadorModulo10
    port map
    (
        clock => clock,
        clr => clear_score_2,
        ent => '1',
        enp => enable_score_2,
        Q => s_score2_unidade,
        rco => s_rco_score2
    );

    contDezena_score_2 : contadorModulo10
    port map
    (
        clock => clock,
        clr => clear_score_2,
        ent => s_rco_score2,
        enp => enable_score_2,
        Q => s_score2_dezena
    );

    HEX_unidade_score2 : hexa7seg
    port map
    (
        hexa =>s_score2_unidade,
        sseg =>s_score2_unidade_sseg
    );

    HEX_dezena_score2 : hexa7seg
    port map
    (
        hexa =>s_score2_dezena,
        sseg =>s_score2_dezena_sseg
    );

    -- SCORE_TOTAL

    contUnidade_score_Total : contadorModulo10
    port map
    (
        clock => clock,
        clr => clear_score_Total,
        ent => '1',
        enp => enable_score_Total,
        Q => s_scoreTotal_unidade,
        rco => s_rco_scoreTotal
    );

    contDezena_score_Total : contadorModulo10
    port map
    (
        clock => clock,
        clr => clear_score_Total,
        ent => s_rco_scoreTotal,
        enp => enable_score_Total,
        Q => s_scoreTotal_dezena
    );

    HEX_unidade_scoreTotal : hexa7seg
    port map
    (
        hexa =>s_scoreTotal_unidade,
        sseg =>s_scoreTotal_unidade_sseg
    );

    HEX_dezena_scoreTotal : hexa7seg
    port map
    (
        hexa =>s_scoreTotal_dezena,
        sseg =>s_scoreTotal_dezena_sseg
    );


    score_1(13 downto 7) <= s_score1_dezena_sseg;
    score_1(6 downto 0) <= s_score1_unidade_sseg;

    score_2(13 downto 7) <= s_score2_dezena_sseg;
    score_2(6 downto 0) <= s_score2_unidade_sseg;

    score_total(13 downto 7) <= s_scoreTotal_dezena_sseg; 
    score_total(6 downto 0) <= s_scoreTotal_unidade_sseg; 


end architecture scoreCounter_arch;