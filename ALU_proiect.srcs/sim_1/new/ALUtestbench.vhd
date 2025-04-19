library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALUtestbench is
-- No ports for a testbench
end ALUtestbench;

architecture Behavioral of ALUtestbench is

  -- Component Declaration
  component FloatingPointALU
    Port (
         A      : in  std_logic_vector(31 downto 0);
         B      : in  std_logic_vector(31 downto 0);
         opcode : in  std_logic_vector(1 downto 0); -- 00: Add, 01: Multiply, 10: Divide
         clk    : in  std_logic;
         reset  : in  std_logic;
         result : out std_logic_vector(31 downto 0)
         );
  end component;

  -- Signals
  signal A, B     : std_logic_vector(31 downto 0);
  signal opcode   : std_logic_vector(1 downto 0);
  signal clk      : std_logic := '0';
  signal reset    : std_logic := '1';
  signal result   : std_logic_vector(31 downto 0);

  -- Constants for test values
  constant X1 : std_logic_vector(31 downto 0) := "00111111001000000000000000000000"; -- 0.625
  constant Y1 : std_logic_vector(31 downto 0) := "10111110111000000000000000000000"; -- -0.4375
  constant X2 : std_logic_vector(31 downto 0) := "00111111010000000000000000000000"; -- 0.75
  constant Y2 : std_logic_vector(31 downto 0) := "11000000101000000000000000000000"; -- -5.0

  -- Clock period
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the ALU
  UUT: ALU
    port map (
      A => A,
      B => B,
      opcode => opcode,
      clk => clk,
      reset => reset,
      result => result
    );

  -- Clock process
  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
    wait;
  end process;

  -- Test process
  test_process : process
  begin
    -- Reset the system
    reset <= '1';
    wait for clk_period * 2;
    reset <= '0';

    -- Test 1: Addition (X = 0.625, Y = -0.4375)
    A <= X1;
    B <= Y1;
    opcode <= "00"; -- Add
    wait for clk_period * 10;

    -- Test 2: Multiplication (X = 0.75, Y = -5.0)
    A <= X2;
    B <= Y2;
    opcode <= "01"; -- Multiply
    wait for clk_period * 10;

    -- Test 3: Division (X = 0.75, Y = -5.0)
    A <= X2;
    B <= Y2;
    opcode <= "10"; -- Divide
    wait for clk_period * 10;

    -- End simulation
    wait;
  end process;

end Behavioral;