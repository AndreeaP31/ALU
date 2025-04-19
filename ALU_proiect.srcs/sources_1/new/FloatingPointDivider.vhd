library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FloatingPointDivider is
  Port (
       A      : in  std_logic_vector(31 downto 0);
       B      : in  std_logic_vector(31 downto 0);
       clk    : in  std_logic;
       reset  : in  std_logic;
       rez    : out std_logic_vector(31 downto 0)
       );
end FloatingPointDivider;

architecture Behavioral of FloatingPointDivider is
  type ST is (WAIT_STATE, DIVIDE_STATE, NORMALIZE_STATE, OUTPUT_STATE);
  signal state : ST := WAIT_STATE;

  signal A_mantissa, B_mantissa : std_logic_vector(23 downto 0);
  signal A_exp, B_exp           : std_logic_vector(8 downto 0);
  signal A_sgn, B_sgn           : std_logic;
  signal rez_exp                : std_logic_vector(8 downto 0);
  signal rez_full_mantissa      : std_logic_vector(49 downto 0);
  signal rez_sgn                : std_logic;
  constant NAN : std_logic_vector(31 downto 0) := "01111111110000000000000000000000";

begin
  process (clk, reset)
  begin
    if reset = '1' then
      state <= WAIT_STATE;
      rez <= (others => '0');
    elsif rising_edge(clk) then
      case state is
        when WAIT_STATE =>
          if unsigned(B(30 downto 0)) = 0 then
            rez <= NAN;
            state <= OUTPUT_STATE;
          else
            A_sgn      <= A(31);
            A_exp      <= '0' & A(30 downto 23);
            A_mantissa <= "1" & A(22 downto 0);
            B_sgn      <= B(31);
            B_exp      <= '0' & B(30 downto 23);
            B_mantissa <= "1" & B(22 downto 0);
            state <= DIVIDE_STATE;
          end if;
        when DIVIDE_STATE =>
          rez_sgn <= A_sgn xor B_sgn;
          rez_exp <= std_logic_vector(signed(A_exp) - signed(B_exp) + 127);
          rez_full_mantissa <= std_logic_vector((unsigned(A_mantissa) * (2**23)) / unsigned(B_mantissa));
          state <= NORMALIZE_STATE;
        when NORMALIZE_STATE =>
          if rez_full_mantissa(49) = '1' then
            rez_full_mantissa <= '0' & rez_full_mantissa(49 downto 1);
            rez_exp <= std_logic_vector(unsigned(rez_exp) + 1);
          elsif rez_full_mantissa(48) = '0' then
            rez_full_mantissa <= rez_full_mantissa(48 downto 0) & '0';
            rez_exp <= std_logic_vector(unsigned(rez_exp) - 1);
          else
            state <= OUTPUT_STATE;
          end if;
        when OUTPUT_STATE =>
          rez(31) <= rez_sgn;
          rez(30 downto 23) <= rez_exp(7 downto 0);
          rez(22 downto 0) <= rez_full_mantissa(47 downto 25);
          state <= WAIT_STATE;
        when others =>
          state <= WAIT_STATE;
      end case;
    end if;
  end process;
end Behavioral;
