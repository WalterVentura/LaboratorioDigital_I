-------------------------------------------------------------------
-- Arquivo   : contadorTimeout.vhd
-- Projeto   : Jogo do Desafio da Memória
-------------------------------------------------------------------        
--  Autores:  Walter Daniel Ventura 
--            Antonio Pinheiro da Silva Júnior
--            Vinícius Bueno de Moraes
-------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contadorTimeout is 
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
end entity contadorTimeout;

architecture contadorTimeout_arch of contadorTimeout is

    component contadorRegressivoModulo10 is
        port
        (
            clock : in std_logic;
            clr   : in std_logic;
            ld    : in std_logic;
            ent   : in std_logic;   
            enp   : in std_logic;
            D     : in std_logic_vector(3 downto 0);
            Q     : out std_logic_vector(3 downto 0);
            rco   : out std_logic
        );
    end component contadorRegressivoModulo10;

    component hexa7seg is
        port
        (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component hexa7seg;

    signal s_rco : std_logic_vector(4 downto 0);
    signal s_hexa0 : std_logic_vector(3 downto 0);
    signal s_hexa1 : std_logic_vector(3 downto 0);
    signal s_hexa2 : std_logic_vector(3 downto 0);
    signal s_hexa3 : std_logic_vector(3 downto 0);
    signal s_hexa4 : std_logic_vector(3 downto 0);

begin

    ContaUnidade : contadorRegressivoModulo10
    port map
    (
        clock => clock,
        clr => clr,
        ld => ld,
        ent => enable,
        enp => enable,
        D => "0000",
        Q => s_hexa0,
        rco => s_rco(0)
    );

    ContaDezena : contadorRegressivoModulo10
    port map
    (
        clock => clock,
        clr => clr,
        ld => ld,
        ent => s_rco(0),
        enp => enable,
        D => "0000",
        Q => s_hexa1,
        rco => s_rco(1)
    );

    ContaCentena : contadorRegressivoModulo10
    port map
    (
        clock => clock,
        clr => clr,
        ld => ld,
        ent => s_rco(0) and s_rco(1),
        enp => enable,
        D => "0000",
        Q => s_hexa2,
        rco => s_rco(2)
    );

    ContaMilhar: contadorRegressivoModulo10
    port map
    (
        clock => clock,
        clr => clr,
        ld => ld,
        ent => s_rco(0) and s_rco(1) and s_rco(2),
        enp => enable,
        D => D(3 downto 0),
        Q => s_hexa3,
        rco => s_rco(3)
    );

    ContaDezenaDeMilhar : contadorRegressivoModulo10
    port map
    (
        clock => clock,
        clr => clr,
        ld => ld,
        ent =>  s_rco(0) and s_rco(1) and s_rco(2) and s_rco(3),
        enp => enable, 
        D => D(7 downto 4),
        Q => s_hexa4,
        rco => s_rco(4)
    );

    HEX0 : hexa7seg
    port map
    (
        hexa => s_hexa0,
        sseg => open
    );

    HEX1 : hexa7seg
    port map
    (
        hexa => s_hexa1,
        sseg => open
    );

    HEX2 : hexa7seg
    port map
    (
        hexa => s_hexa2,
        sseg => Q(6 downto 0)
    );

    HEX3 : hexa7seg
    port map
    (
        hexa => s_hexa3,
        sseg => Q(13 downto 7)
    );

    HEX4 : hexa7seg
    port map
    (
        hexa => s_hexa4,
        sseg => Q(20 downto 14)
    );

    rco <= s_rco(0) and s_rco(1) and s_rco(2) and s_rco(3) and s_rco(4);

end architecture contadorTimeout_arch;