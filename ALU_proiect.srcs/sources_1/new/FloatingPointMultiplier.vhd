library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FloatingPointMultiplier is
  Port (
       A      : in  std_logic_vector(31 downto 0);
       B      : in  std_logic_vector(31 downto 0);
       clk    : in  std_logic;
       reset  : in  std_logic;
       mul    : out std_logic_vector(31 downto 0)
       );
end FloatingPointMultiplier;

architecture Behavioral of FloatingPointMultiplier is
  type ST is (WAIT_STATE, MULTIPLY_STATE, NORMALIZE_STATE, OUTPUT_STATE);
  signal state : ST := WAIT_STATE;

  signal A_mantissa, B_mantissa : std_logic_vector(23 downto 0);
  signal A_exp, B_exp           : std_logic_vector(8 downto 0);
  signal A_sgn, B_sgn           : std_logic;
  signal mul_exp                : std_logic_vector(8 downto 0);
  signal mul_full_mantissa      : std_logic_vector(49 downto 0);
  signal mul_sgn                : std_logic;

begin
  process (clk, reset)
  begin
    if reset = '1' then
      state <= WAIT_STATE;
      mul <= (others => '0');
    elsif rising_edge(clk) then
      case state is
        when WAIT_STATE =>
          if (unsigned(A(30 downto 0)) = 0 or unsigned(B(30 downto 0)) = 0) then
            mul <= (others => '0');
            state <= OUTPUT_STATE;
          else
            A_sgn      <= A(31);
            A_exp      <= '0' & A(30 downto 23);
            A_mantissa <= "1" & A(22 downto 0);
            B_sgn      <= B(31);
            B_exp      <= '0' & B(30 downto 23);
            B_mantissa <= "1" & B(22 downto 0);
            state <= MULTIPLY_STATE;
          end if;
        when MULTIPLY_STATE =>
          mul_sgn <= A_sgn xor B_sgn;
          mul_exp <= std_logic_vector(unsigned(A_exp) + unsigned(B_exp) - 127);
          mul_full_mantissa <= std_logic_vector(unsigned(A_mantissa) * unsigned(B_mantissa));
          state <= NORMALIZE_STATE;
        when NORMALIZE_STATE =>
          if mul_full_mantissa(49) = '1' then
            mul_full_mantissa <= '0' & mul_full_mantissa(49 downto 1);
            mul_exp <= std_logic_vector(unsigned(mul_exp) + 1);
          elsif mul_full_mantissa(48) = '0' then
            mul_full_mantissa <= mul_full_mantissa(48 downto 0) & '0';
            mul_exp <= std_logic_vector(unsigned(mul_exp) - 1);
          else
            state <= OUTPUT_STATE;
          end if;
        when OUTPUT_STATE =>
          mul(31) <= mul_sgn;
          mul(30 downto 23) <= mul_exp(7 downto 0);
          mul(22 downto 0) <= mul_full_mantissa(47 downto 25);
          state <= WAIT_STATE;
        when others =>
          state <= WAIT_STATE;
      end case;
    end if;
  end process;
end Behavioral;
