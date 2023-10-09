library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity TB is
	generic(g_bits:integer:=10
				;g_lines:integer:=15);
end entity;

Architecture RTL of TB is
	component Custom_Pulse is
		generic
					(g_bits:integer:=g_bits
					;g_lines:integer:=g_lines
					);
		port
				(i_Clk:in std_logic
				;i_reset:in std_logic
				;i_sta:in std_logic
				;i_Data:in std_logic_vector(g_bits-1 downto 0)
				;o_Data:out std_logic_vector(g_bits-1 downto 0)
				;o_Addr:out std_logic_vector(g_lines-1 downto 0)
				;flag:out std_logic
				);
	end component;
	component ROM_Test_Bench is
		generic(g_bits:integer:=g_bits
					;g_lines:integer:=g_lines);
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (g_lines-1 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			q		: OUT STD_LOGIC_VECTOR (g_bits-1 DOWNTO 0)
		);
	END component;
	
	signal s_Clk:std_logic;
	signal s_reset:std_logic;
	signal s_sta:std_logic;
	signal s_DataIn:std_logic_vector(g_bits-1 downto 0);
	signal s_DataOut:std_logic_vector(g_bits-1 downto 0);
	signal s_Addr:std_logic_vector(g_lines-1 downto 0);
	signal flag:std_logic;
	
	file fcustom:text;
		
begin
	--Señal de reinicio
	process
	begin
		s_reset <= '0';
		wait for 10 ns;
		s_reset <= '1';
		wait;
	end process;
	--Señal de inicio
	process
	begin
		s_sta	<=	'0';
		wait for 10 ns;
		s_sta	<=	'1';
		wait for 10 ns;
		s_sta <= '0';
		wait;
	end process;
	--señal de reloj
	process
	begin
		s_Clk <= '0';
		wait for 5 ns;
		s_Clk <= '1';
		wait for 5 ns;
	end process;
	--Almacenamiento de datos
	process(s_Clk)
		variable l:line;
		variable status:file_open_status;
	begin
		if (rising_edge(s_Clk)) then
			file_open(status,fcustom,"C:\Users\Joan\Documents\TG\Senales\Custom_Pulse\custom3.txt",append_mode);
			assert status=open_ok
				report "No se pudo crear custom.txt"
				severity failure;
			write(l,to_integer(signed(s_DataOut)));
			writeline(fcustom,l);
			file_close(fcustom);
		end if;
	end process;
	CP:	Custom_Pulse	port map (s_Clk,s_reset,s_sta,s_DataIn,s_DataOut,s_Addr,flag);
	ROM:	ROM_Test_Bench	port map (s_Addr,s_Clk,s_DataIN);
end RTL;