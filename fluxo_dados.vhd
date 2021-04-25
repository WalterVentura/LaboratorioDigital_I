-------------------------------------------------------------------
-- Arquivo   : fluxo_dados.vhd
-- Projeto   : Projeto Base do Jogo do Desafio da Memória
-------------------------------------------------------------------        
--  Autores:  Walter Daniel Ventura 
--            Antonio Pinheiro da Silva Júnior
--            Vinícius Bueno de Moraes
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados is 
    port
    (
        clock                      : in  std_logic;
        zeraL                      : in  std_logic;
        contaLMais                 : in  std_logic;
        contaLMenos                : in  std_logic;
        zeraE                      : in  std_logic;
        contaE                     : in  std_logic;
        escreve                    : in  std_logic;
        botoes                     : in  std_logic_vector(3 downto 0);
        registraR                  : in  std_logic;
        limpaR                     : in  std_logic;
        nivel                      : in  std_logic_vector(1 downto 0);
        iniciar                    : in  std_logic;
        enderecoDeEscrita          : out std_logic;
        chavesIgualMemoria         : out std_logic;
        enderecoFimDeJogo          : out std_logic;
        db_limite                  : out std_logic_vector(3 downto 0);
        db_contagem                : out std_logic_vector(3 downto 0);
        db_memoria                 : out std_logic_vector(3 downto 0);
        db_jogada                  : out std_logic_vector(3 downto 0)
    );
end entity fluxo_dados;

architecture fluxo_dados_arch of fluxo_dados is

    component contador_163 is
        port
        (
             clock : in  std_logic;
             clr   : in  std_logic;
             ld    : in  std_logic;
             ent   : in  std_logic;
             enp   : in  std_logic;
             D     : in  std_logic_vector (3 downto 0);
             Q     : out std_logic_vector (3 downto 0);
             rco   : out std_logic 
        );
    end component;

    component contador_163_modificado is
        port 
        (
             clock        : in  std_logic;
             clr          : in  std_logic;
             ld           : in  std_logic;
             ent          : in  std_logic;
             enableMais   : in  std_logic;
             enableMenos  : in  std_logic;
             D            : in  std_logic_vector (3 downto 0);
             Q            : out std_logic_vector (3 downto 0);
             rco          : out std_logic 
        );
     end component;

    component comparador_85 is
        port 
        (
          i_A3   : in  std_logic;
          i_B3   : in  std_logic;
          i_A2   : in  std_logic;
          i_B2   : in  std_logic;
          i_A1   : in  std_logic;
          i_B1   : in  std_logic;
          i_A0   : in  std_logic;
          i_B0   : in  std_logic;
          i_AGTB : in  std_logic;
          i_ALTB : in  std_logic;
          i_AEQB : in  std_logic;
          o_AGTB : out std_logic;
          o_ALTB : out std_logic;
          o_AEQB : out std_logic
        );
    end component;

    component ram_16x4 is
        port 
        (
            clk          : in  std_logic;
            endereco     : in  std_logic_vector(3 downto 0);
            dado_entrada : in  std_logic_vector(3 downto 0);
            we           : in  std_logic;
            ce           : in  std_logic;
            dado_saida   : out std_logic_vector(3 downto 0)
        );
    end component;

    component registrador_4bits is
        port 
        (
          clock:  in  std_logic;
          clear:  in  std_logic;
          enable: in  std_logic;
          D:      in  std_logic_vector(3 downto 0);
          Q:      out std_logic_vector(3 downto 0)
        );
    end component;

    component mux4_4to1 is
        port 
        (
          SEL : in  std_logic_vector(1 downto 0);    
          A   : in  std_logic_vector(3 downto 0);
          B   : in  std_logic_vector(3 downto 0);
          C   : in  std_logic_vector(3 downto 0);
          D   : in  std_logic_vector(3 downto 0);
          Y   : out std_logic_vector(3 downto 0)
        );
    end component mux4_4to1;


    signal s_zeraL : std_logic;
    signal s_zeraE : std_logic;
    signal s_limite : std_logic_vector(3 downto 0);
    signal s_endereco : std_logic_vector(3 downto 0);
    signal s_jogada : std_logic_vector(3 downto 0);
    signal s_dado : std_logic_vector(3 downto 0);
    signal s_dificuldade : std_logic_vector(3 downto 0);
    signal s_escreve : std_logic;

begin

    s_zeraL <= not zeraL;
    s_zeraE <= not zeraE;
    s_escreve <= not escreve;

    ContLmt : contador_163_modificado
    port map
    (
        clock => clock,
        clr => s_zeraL,
        ld => '1',
        ent => '1',
        enableMais => contaLMais,
        enableMenos => contaLMenos, 
        D => "0000",
        Q => s_limite,
        rco => open
    );

    ContEnd : contador_163
    port map
    (
        clock => clock,
        clr => s_zeraE,
        ld => '1',
        ent => '1',
        enp => contaE,
        D => "0000",
        Q => s_endereco,
        rco => open
    );

    CompLmt : comparador_85
    port map
    (
        i_A3 => s_limite(3),
        i_B3 => s_endereco(3), 
        i_A2 => s_limite(2),
        i_B2 => s_endereco(2),
        i_A1 => s_limite(1),
        i_B1 => s_endereco(1),
        i_A0 => s_limite(0),
        i_B0 => s_endereco(0),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => open,
        o_ALTB => open,
        o_AEQB => enderecoDeEscrita
    );

    MemJog : ram_16x4
    port map
    (
        clk => clock,
        endereco => s_endereco,
        dado_entrada => s_jogada,
        we => s_escreve,
        ce => '0',
        dado_saida => s_dado
    );

    RegBotoes : registrador_4bits 
    port map
    (
        clock => clock,
        clear => limpaR,  
        enable => registraR,
        D => botoes,      
        Q => s_jogada
    );

    CompJog : comparador_85
    port map
    (
        i_A3 => s_dado(3),
        i_B3 => s_jogada(3), 
        i_A2 => s_dado(2),
        i_B2 => s_jogada(2),
        i_A1 => s_dado(1),
        i_B1 => s_jogada(1),
        i_A0 => s_dado(0),
        i_B0 => s_jogada(0),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => open,
        o_ALTB => open,
        o_AEQB => chavesIgualmemoria
    );

    MuxDificuldade : mux4_4to1 
    port map
    (
        SEL => nivel, 
        A => "0011",
        B => "0111",
        C => "1011",
        D => "1111",
        Y => s_dificuldade
    );

    CompDificuldade : comparador_85
    port map
    (
        i_A3 => s_dificuldade(3),
        i_B3 => s_limite(3), 
        i_A2 => s_dificuldade(2),
        i_B2 => s_limite(2),
        i_A1 => s_dificuldade(1),
        i_B1 => s_limite(1),
        i_A0 => s_dificuldade(0),
        i_B0 => s_limite(0),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => open,
        o_ALTB => open,
        o_AEQB => enderecoFimDeJogo
    );

    db_limite <= s_limite;
    db_contagem <= s_endereco;
    db_memoria <= s_dado;
    db_jogada <= s_jogada;

end architecture fluxo_dados_arch ; 