----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2022 06:36:29 PM
-- Design Name: 
-- Module Name: ID_comp - Behavioral
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

entity ID_comp is
     Port (  clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (12 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
            rd_mem : in STD_LOGIC_VECTOR (2 downto 0);
           regWrite : in STD_LOGIC;
           regOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : OUT STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC;
           rt: out STD_LOGIC_VECTOR (2 downto 0);
           rd: out STD_LOGIC_VECTOR (2 downto 0));
end ID_comp;

architecture Behavioral of ID_comp is
signal input: STD_LOGIC_VECTOR(2 downto 0);

type IDtype is array(0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
    signal ID: IDtype := (
        x"0000",
        x"000F",
        x"0005",
        x"000F",
        x"0005",
        x"0002",
        x"0002",
       others => x"1234");
begin

    -- extindere
    rt <= instruction(9 downto 7);
    rd <= instruction(6 downto 4);
    process(regOp, instruction)
    begin
        if regOp = '0' then
            Ext_Imm <= "000000000" & instruction(6 downto 0);
        else
            if instruction(6) = '1' then
                  Ext_Imm <= "111111111" & instruction(6 downto 0);
             else
                 Ext_Imm <= "000000000" & instruction(6 downto 0);
            end if;
         end if;
    end process;
    
    process(clk, enable, regWrite, wd, rd_mem)
    begin
       if falling_edge(clk) then
           if  regWrite = '1'  then
               ID(conv_integer(rd_mem)) <= wd;
           end if;
       end if;
  end process;
  
  rd1 <= ID(conv_integer(instruction(12 downto 10)));
  rd2 <= ID(conv_integer(instruction(9 downto 7)));
  
  func <= instruction(2 downto 0);
  sa <= instruction(3);
  



end Behavioral;
