----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2022 12:26:15 PM
-- Design Name: 
-- Module Name: MainUnit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MainUnit is
    Port ( Instruction : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : inout STD_LOGIC;
           RegOp : inout STD_LOGIC;
           ALUSrc : inout STD_LOGIC;
           Branch : inout STD_LOGIC;
           Jump : inout STD_LOGIC;
           ALUOp : inout STD_LOGIC_VECTOR(2 downto 0);
           MemWrite : inout STD_LOGIC;
           MemtoReg : inout STD_LOGIC;
           RegWrite : inout STD_LOGIC);
end MainUnit;

architecture Behavioral of MainUnit is

begin
    process(Instruction)
    begin
        if Instruction = "000" then -- sub
            RegDst <= '1';
            RegOp <= '0';
            ALUSrc <= '0';
            Branch <= '0';
            Jump <= '0';
            MemWrite <= '0';
            MemtoReg <= '0';
            RegWrite <= '1';
            ALUOp <= "000";
         elsif Instruction = "010" then -- addi
                        RegDst <= '0';
                        RegOp <= '1';
                        ALUSrc <= '1';
                        Branch <= '0';
                        Jump <= '0';
                        MemWrite <= '0';
                        MemtoReg <= '0';
                        RegWrite <= '1';
                        ALUOp <= "010";
 elsif Instruction = "100" then -- beq
                                                RegDst <= '0';
                                                RegOp <= '1';
                                                ALUSrc <= '0';
                                                Branch <= '1';
                                                Jump <= '0';
                                                MemWrite <= '0';
                                                MemtoReg <= '0';
                                                RegWrite <= '0';
                                                ALUOp <= "100";                                
         elsif Instruction = "101" then -- ble
                                                        RegDst <= '0';
                                                        RegOp <= '1';
                                                        ALUSrc <= '0';
                                                        Branch <= '1';
                                                        Jump <= '0';
                                                        MemWrite <= '0';
                                                        MemtoReg <= '0';
                                                        RegWrite <= '0';
                                                        ALUOp <= "101";
         elsif Instruction = "111" then -- jump
             RegDst <= '0';
                                                                RegOp <= '0';
                                                                ALUSrc <= '0';
                                                                Branch <= '0';
                                                                Jump <= '1';
                                                                MemWrite <= '0';
                                                                MemtoReg <= '0';
                                                                RegWrite <= '0';
                                                                ALUOp <= "111";
         elsif Instruction = "001" then -- noop
                                                                                                                        RegDst <= '1';
                                                                                                                        RegOp <= '0';
                                                                                                                        ALUSrc <= '0';
                                                                                                                        Branch <= '0';
                                                                                                                        Jump <= '0';
                                                                                                                        MemWrite <= '0';
                                                                                                                        MemtoReg <= '0';
                                                                                                                        RegWrite <= '0';
                                                                                                                        ALUOp <= "001";
         end if;
    end process;

end Behavioral;
