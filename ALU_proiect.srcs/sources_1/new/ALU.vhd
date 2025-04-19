library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
  Port (
       A      : in  std_logic_vector(31 downto 0);
       B      : in  std_logic_vector(31 downto 0);
       opcode : in  std_logic_vector(1 downto 0); -- 00: Add, 01: Multiply, 10: Divide
       clk    : in  std_logic;
       reset  : in  std_logic;
       result : out std_logic_vector(31 downto 0)
       );
end ALU;

architecture Behavioral of ALU is
  signal add_result, mul_result, div_result : std_logic_vector(31 downto 0);
  signal current_result : std_logic_vector(31 downto 0);

  component FloatingPointAdder
    Port (
         A      : in  std_logic_vector(31 downto 0);
         B      : in  std_logic_vector(31 downto 0);
         clk    : in  std_logic;
         reset  : in  std_logic;
         sum    : out std_logic_vector(31 downto 0)
         );
  end component;

  component FloatingPointMultiplier
    Port (
         A      : in  std_logic_vector(31 downto 0);
         B      : in  std_logic_vector(31 downto 0);
         clk    : in  std_logic;
         reset  : in  std_logic;
         mul    : out std_logic_vector(31 downto 0)
         );
  end component;

  component FloatingPointDivider
    Port (
         A      : in  std_logic_vector(31 downto 0);
         B      : in  std_logic_vector(31 downto 0);
         clk    : in  std_logic;
         reset  : in  std_logic;
         rez    : out std_logic_vector(31 downto 0)
         );
  end component;

begin
  Adder: FloatingPointAdder
    port map (
      A => A,
      B => B,
      clk => clk,
      reset => reset,
      sum => add_result
    );

  Multiplier: FloatingPointMultiplier
    port map (
      A => A,
      B => B,
      clk => clk,
      reset => reset,
      mul => mul_result
    );

  Divider: FloatingPointDivider
    port map (
      A => A,
      B => B,
      clk => clk,
      reset => reset,
      rez => div_result
    );

  process (add_result, mul_result, div_result, opcode)
  begin
    case opcode is
      when "00" =>
        current_result <= add_result;
      when "01" =>
        current_result <= mul_result;
      when "10" =>
        current_result <= div_result;
      when others =>
        current_result <= (others => '0');
    end case;
  end process;

  result <= current_result;

end Behavioral;
