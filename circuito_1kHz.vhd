-------------------------------------------------------------------
-- Arquivo   : circuito_1kHz.vhd
-- Projeto   : Jogo do Desafio da Memória
-------------------------------------------------------------------        
--  Autores:  Walter Daniel Ventura 
--            Antonio Pinheiro da Silva Júnior
--            Vinícius Bueno de Moraes
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity circuito_1kHz is
    port 
    (
        clock       : in  std_logic;
        reset       : in  std_logic;
        jogar       : in  std_logic;
        repetir     : in  std_logic;
        botoes      : in  std_logic_vector(3 downto 0);
        nivel       : in  std_logic_vector(1 downto 0);
        modo        : in  std_logic;
        leds        : out std_logic_vector(3 downto 0);
        display_0   : out std_logic_vector(6 downto 0);
        display_1   : out std_logic_vector(6 downto 0);
        display_2   : out std_logic_vector(6 downto 0);
        display_3   : out std_logic_vector(6 downto 0);
        display_4   : out std_logic_vector(6 downto 0);
        display_5   : out std_logic_vector(6 downto 0)
    );
end entity circuito_1kHz;

architecture circuito_1kHz_arch of circuito_1kHz is

    component fluxo_dados is 
        port
        (
            clock                : in  std_logic;
            zeraL                : in  std_logic;
            contaLMais           : in  std_logic;
            contaLMenos          : in  std_logic;
            zeraE                : in  std_logic;
            contaE               : in  std_logic;
            escreve              : in  std_logic;
            botoes               : in  std_logic_vector(3 downto 0);
            registraR            : in  std_logic;
            limpaR               : in  std_logic;
            iniciar              : in  std_logic;
            nivel                : in  std_logic_vector(1 downto 0);
            enderecoDeEscrita    : out std_logic;
            chavesIgualMemoria   : out std_logic;
            enderecoFimDeJogo    : out std_logic;
            db_limite            : out std_logic_vector(3 downto 0);
            db_contagem          : out std_logic_vector(3 downto 0);
            db_memoria           : out std_logic_vector(3 downto 0);
            db_jogada            : out std_logic_vector(3 downto 0)
        );
    end component fluxo_dados;

    component unidade_controle is 
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
    end component;
	 
    component edge_detector is
        port 
        (
          clock  : in  std_logic;
          reset  : in  std_logic;
          sinal  : in  std_logic;
          pulso  : out std_logic
        );
    end component edge_detector;

    component geradorAleatorio is 
        port 
        (
            clock     : in std_logic;
            aleatorio : out std_logic_vector (3 downto 0)
        );
    end component geradorAleatorio;
     
    component contadorTimeout is 
    port 
    (
        clock  : in std_logic;
        clr    : in std_logic;
        ld     : in std_logic;
        enable : in std_logic;
        D      : in std_logic_vector (7 downto 0);
        Q      : out std_logic_vector (20 downto 0);
        rco    : out std_logic
    );
    end component; 

    component contador1000ciclos is 
        port 
        (
            clock : in std_logic;
            clr   : in std_logic;
            ld    : in std_logic;
            ent   : in std_logic;
            enp   : in std_logic;
            D     : in std_logic_vector (9 downto 0);
            Q     : out std_logic_vector (9 downto 0);
            rco   : out std_logic
        );
    end component contador1000ciclos;    

    component contadorDisplay is 
        port 
        (
            clock : in std_logic;
            clr   : in std_logic;
            ld    : in std_logic;
            ent   : in std_logic;
            enp   : in std_logic;
            D     : in std_logic_vector (9 downto 0);
            Q     : out std_logic_vector (9 downto 0);
            rco   : out std_logic
        );
    end component contadorDisplay;

    component contador200ciclos is 
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
    end component contador200ciclos;

    component mux4_2to1 is
        port 
        (
          SEL : in  std_logic;    
          A   : in  std_logic_vector(3 downto 0);
          B   : in  std_logic_vector(3 downto 0);
          Y   : out std_logic_vector(3 downto 0)
        );
    end component mux4_2to1;

    component mux8_4to1 is
        port 
        (
          SEL : in  std_logic_vector(1 downto 0);    
          A   : in  std_logic_vector(7 downto 0);
          B   : in  std_logic_vector(7 downto 0);
          C   : in  std_logic_vector(7 downto 0);
          D   : in  std_logic_vector(7 downto 0);
          Y   : out std_logic_vector(7 downto 0)
        );
    end component mux8_4to1;

    component seletorPalavras is
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
    end component seletorPalavras;

    component scoreCounter is
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
    end component scoreCounter;

    component controladorLeds is
        port 
        (
          estado      : in  std_logic_vector(4 downto 0);
          db_memoria  : in  std_logic_vector(3 downto 0);
          db_jogada   : in  std_logic_vector(3 downto 0);
          leds        : out std_logic_vector(3 downto 0)
        );
    end component controladorLeds;
    

    signal s_zeraL : std_logic;
    signal s_contaLMais : std_logic;
    signal s_contaLMenos : std_logic;
    signal s_zeraE : std_logic;
    signal s_contaE : std_logic;
    signal s_registra : std_logic;
    signal s_enderecoDeEscrita : std_logic;
    signal s_igual : std_logic;
  
    signal s_limite : std_logic_vector(3 downto 0);
    signal s_contagem : std_logic_vector(3 downto 0);
    signal s_memoria : std_logic_vector(3 downto 0);
    signal s_jogada : std_logic_vector(3 downto 0);
    signal s_estado : std_logic_vector(4 downto 0);
	 
    signal s_pulso : std_logic;
    
    signal s_escreve : std_logic;
    signal s_timeout : std_logic;
    signal s_timeoutValue : std_logic_vector(7 downto 0);
    signal s_zeraTimeout : std_logic;
    signal s_notZeraTimeout : std_logic;
    signal s_timeoutRepeticao : std_logic;
    signal s_zeraTimeoutRepeticao : std_logic;
    signal s_notZeraTimeoutRepeticao : std_logic;    

    signal s_sinal : std_logic;

    signal s_enderecoFimDeJogo : std_logic;
    
    signal s_displays : std_logic_vector(41 downto 0);
    signal  s_timeoutHex : std_logic_vector(20 downto 0);

    signal s_seletorMuxBot : std_logic;
    signal s_aleatorio : std_logic_vector(3 downto 0);
    signal s_botoes : std_logic_vector(3 downto 0);

    signal s_timeoutDisplays : std_logic;
    signal s_zeraTimeoutDisplays : std_logic;
    signal s_notZeraTimeoutDisplays : std_logic;   
    signal s_timeoutDelay : std_logic;
    signal s_zeraTimeoutDelay : std_logic;
    signal s_notZeraTimeoutDelay : std_logic;   

    signal s_enable_score_1 : std_logic;
    signal s_enable_score_2 : std_logic;
    signal s_enable_score_total : std_logic;
    signal s_clear_score_1 : std_logic;
    signal s_clear_score_2 : std_logic;
    signal s_clear_score_total : std_logic;
    signal s_score_1 : std_logic_vector(13 downto 0);
    signal s_score_2 : std_logic_vector(13 downto 0);
    signal s_score_total : std_logic_vector(13 downto 0);


begin

    FD: fluxo_dados
    port map
    (
        clock => clock,                     
        zeraL => s_zeraL,                     
        contaLMais => s_contaLMais,
        contaLMenos => s_contaLMenos,                   
        zeraE => s_zeraE,                  
        contaE => s_contaE,                   
        escreve => s_escreve,                  
        botoes => s_botoes,    
        registraR => s_registra,                  
        limpaR => '0',  
        iniciar => jogar,
        nivel => nivel,                                         
        enderecoDeEscrita => s_enderecoDeEscrita,
        chavesIgualMemoria => s_igual,
        enderecoFimDeJogo => s_enderecoFimDeJogo, 
        db_limite => s_limite,
        db_contagem => s_contagem,  
        db_memoria => s_memoria,
        db_jogada => s_jogada
    );

    UC: unidade_controle
    port map
    ( 
        clock => clock,    
        reset => reset,  
        jogar => jogar, 
        enderecoDeEscrita => s_enderecoDeEscrita, 
        enderecoFimDeJogo => s_enderecoFimDeJogo,
        jogada => s_pulso,    
        igual => s_igual,
        timeout => s_timeout,
        repete => repetir,
        repeteTimeout => s_timeoutRepeticao, 
        displaysTimeout => s_timeoutDisplays, 
        delayTimeout => s_timeoutDelay,
        modo => modo,
        zeraL => s_zeraL,     
        zeraE => s_zeraE,     
        contaLMais => s_contaLMais,
        contaLMenos => s_contaLMenos,     
        contaE => s_contaE,    
        registra => s_registra, 
        escreve => s_escreve,
        zeraTimeout => s_zeraTimeout,
        zeraTimeoutRepeticao => s_zeraTimeoutRepeticao,
        zeraTimeoutDisplays => s_zeraTimeoutDisplays, 
        zeraTimeoutDelay => s_zeraTimeoutDelay, 
        seletorMuxBot => s_seletorMuxBot,
        enable_score_1 => s_enable_score_1, 
        enable_score_2 => s_enable_score_2, 
        enable_score_total => s_enable_score_total, 
        clear_score_1 => s_clear_score_1, 
        clear_score_2 => s_clear_score_2, 
        clear_score_total => s_clear_score_total, 
        db_estado => s_estado
    );
    
    ContaScore : scoreCounter
    port map
    (
        clock => clock,
        enable_score_1 => s_enable_score_1,
        enable_score_2 => s_enable_score_2,
        enable_score_total => s_enable_score_total,
        clear_score_1 => s_clear_score_1,
        clear_score_2 => s_clear_score_2,
        clear_score_total => s_clear_score_total,
        score_1 => s_score_1,
        score_2 => s_score_2,
        score_total => s_score_total
    );
    
    s_notZeraTimeoutDisplays <= not s_zeraTimeoutDisplays;
    ContadorDisplaysTimeout : contadorDisplay
    port map
    (
        clock => clock,
        clr => s_notZeraTimeoutDisplays,
        ld => '1',
        ent => '1',
        enp => '1',
        D => "0000000000",
        Q => open,
        rco => s_timeoutDisplays
    );

    s_notZeraTimeoutDelay <= not s_zeraTimeoutDelay;
    ContadorDelayTimeout : contador200ciclos
    port map
    (
        clock => clock,
        clr => s_notZeraTimeoutDelay,
        ld => '1',
        ent => '1',
        enp => '1',
        D => "00000000",
        Q => open,
        rco => s_timeoutDelay
    );


    s_sinal <= botoes(3) or botoes(2) or botoes(1) or botoes(0);
    JGD : edge_detector
    port map
    (
        clock => clock,
        reset => jogar,
        sinal => s_sinal,
        pulso => s_pulso
    );
     
    
    MuxTimeout :  mux8_4to1 
    port map
    (
        SEL => nivel,    
        A   => "00010010", -- 12
        B   => "00001001", -- 09
        C   => "00000110", -- 06
        D   => "00000011", -- 03 
        Y   => s_timeoutValue
    );
        
    s_notZeraTimeout <= not s_zeraTimeout;
    ContTimemout : contadorTimeout
    port map
    (
        clock => clock,
        clr => s_notZeraTimeout,
        ld => jogar,
        enable => '1',
        D => s_timeoutValue,
        Q => s_timeoutHex,
        rco => s_timeout
    );

    s_notZeraTimeoutRepeticao <= not s_zeraTimeoutRepeticao;

    ContRepeticao : contador1000ciclos
    port map
    (
        clock => clock,
        clr => s_notZeraTimeoutRepeticao,
        ld => '1',
        ent => '1',
        enp => '1',
        D => "0000000000",
        Q => open,
        rco => s_timeoutRepeticao
    );

    Gerador_Aleatorio : geradorAleatorio 
    port map
    (
        clock => clock,
        aleatorio => s_aleatorio
    );

    MuxAleatorio : mux4_2to1
    port map
    (
        SEL => s_seletorMuxBot,
        A => botoes,
        B => s_aleatorio,
        Y => s_botoes
    );

    Controlado_Leds : controladorLeds
    port map
    (
        estado => s_estado,
        db_memoria => s_memoria,
        db_jogada => s_jogada,
        leds => leds
    );
    	 
    ControladorDisplay : seletorPalavras
    port map
    (
        estado => s_estado,    
        modo   => modo,
        nivel => nivel,
        score1 => s_score_1,
        score2 => s_score_2,
        scoreTotal => s_score_total, 
        timeout => s_timeoutHex,
        saida   => s_displays
    );

    display_0 <= s_displays(6 downto 0);
    display_1 <= s_displays(13 downto 7);
    display_2 <= s_displays(20 downto 14);
    display_3 <= s_displays(27 downto 21);
    display_4 <= s_displays(34 downto 28);
    display_5 <= s_displays(41 downto 35);
    
end architecture circuito_1kHz_arch;