library ieee;
use ieee.std_logic_1164.all;

entity circuito_completo is
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
end entity circuito_completo;

architecture circuito_completo_arch of circuito_completo is

    component registrador is
        generic
        (
          data_width : integer := 1
        );
        port 
        (
          clock:  in  std_logic;
          clear:  in  std_logic;
          enable: in  std_logic;
          D:      in  std_logic_vector(data_width - 1 downto 0);
          Q:      out std_logic_vector(data_width - 1 downto 0)
        );
      end component registrador;

    
    component edge_detector is
        port 
        (
            clock  : in  std_logic;
            reset  : in  std_logic;
            sinal  : in  std_logic;
            pulso  : out std_logic
        );
    end component edge_detector;

    component prescaler is 
        port 
        (
            clock : in std_logic;
            reset : in std_logic;
            Q     : out std_logic
        );
    end component prescaler;

    component circuito_1kHz is
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
    end component circuito_1kHz;

    signal s_clock : std_logic;
    signal s_jogar : std_logic;
    signal s_nivel : std_logic_vector(1 downto 0);
    
begin

    DetectorBorda : edge_detector
    port map
    (
        clock => s_clock,
        reset => reset,
        sinal => jogar,
        pulso => s_jogar
    );

    PRESCALER_50000 : prescaler 
    port map
    (
        clock => clock,
        reset => reset,
        Q => s_clock
    );

    circuito_1kiloHertz : circuito_1kHz
    port map
    (
        clock => s_clock,
        reset => reset,
        jogar => s_jogar,
        repetir => repetir,
        botoes => botoes,
        nivel => nivel,
        modo => modo,
        leds => leds,
        display_0 => display_0,
        display_1 => display_1,
        display_2 => display_2,
        display_3 => display_3,
        display_4 => display_4,
        display_5 => display_5
    );

end architecture circuito_completo_arch;