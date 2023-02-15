----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2022 04:23:18 PM
-- Design Name: 
-- Module Name: MEM_comp - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM_comp is
   Port (   rWA: in STD_LOGIC_VECTOR (2 downto 0);
            Zero: in STD_LOGIC;
            Branch_ID_EX: in STD_LOGIC;
            MemWrite : in STD_LOGIC;
            ALUResIn : in STD_LOGIC_VECTOR (15 downto 0);
            RD2 : in STD_LOGIC_VECTOR (15 downto 0);
            MemData : out STD_LOGIC_VECTOR (15 downto 0);
            ALUResOut : out STD_LOGIC_VECTOR (15 downto 0);
            RD_MEM_WB: out STD_LOGIC_VECTOR (2 downto 0);
            Branch_EX_MEM: out STD_LOGIC;
            Zero_EX_MEM: out STD_LOGIC;
            enable : in STD_LOGIC;
            clk : in STD_LOGIC);
end MEM_comp;

architecture Behavioral of MEM_comp is
     type MEM is array(0 to 15) of std_logic_vector(15 downto 0);
     signal RAM: MEM := (
            x"0000",
            x"0000",
            X"0000",
            X"0000",
            X"0000",
             OTHERS => X"0000");
  
begin
 
   RD_MEM_WB <= rWA;
    -- write first
     process(clk, enable, MemWrite)
      begin
       if MemWrite = '0' then
           MemData <= RAM(conv_integer(ALUResIn)); 
       end if;
       if rising_edge(clk) then
           if MemWrite = '1' then
               RAM(conv_integer(ALUResIn)) <= RD2;        
           end if;
       end if;
   end process;
    AluResOut <= AluResIn;
end Behavioral;
