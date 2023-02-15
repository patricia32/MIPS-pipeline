----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2022 06:37:02 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX_comp is
  Port ( PC:  in STD_LOGIC_VECTOR(15 downto 0);
         RD1: in STD_LOGIC_VECTOR(15 downto 0);
         RD2: in STD_LOGIC_VECTOR(15 downto 0);
         EXT_IMM: in STD_LOGIC_VECTOR(15 DOWNTO 0);
         ALUSrc: in STD_LOGIC;
         Branch: in STD_LOGIC;
         RegDst: in STD_LOGIC;
         ALUOp: in STD_LOGIC_VECTOR(2 DOWNTO 0);
         rt: in STD_LOGIC_VECTOR(2 DOWNTO 0);
         rd: in STD_LOGIC_VECTOR(2 DOWNTO 0);
         sa: in STD_LOGIC;
         func: in STD_LOGIC_VECTOR(2 downto 0);
         BranchAddress: out STD_LOGIC_VECTOR(15 downto 0);
         ALURes: out STD_LOGIC_VECTOR(15 downto 0); 
         rWA: out STD_LOGIC_VECTOR(2 downto 0); 
         Zero: out STD_LOGIC;
         Branch_ID_EX: out STD_LOGIC);
end EX_comp;

architecture Behavioral of EX_comp is
    signal ALUout, ALUinput2, res: STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal ALUCTRL: STD_LOGIC_VECTOR(2 DOWNTO 0);
begin
    
  BranchAddress <= PC + 1 + EXT_IMM;
    -- MUX
     process(RegDst, rt, rd)
       begin
           if RegDst = '0' then
              rWA <= rt;
           else
              rWA <= rd;
           end if;
       end process;
       
    AluInputMux: process(ALUSrc, RD2, EXT_IMM)
    begin
        if ALUSrc = '0' then
            ALUinput2 <= RD2;
        else
            ALUinput2 <= EXT_IMM;
        end if;
    end process;
    
    -- ALU CONTROL
    
    ALUControl: process(ALUOp, func)
    begin
        if ALUOp = "000" then
            if func = "000" then
                ALUCTRL <= "000";     -- SUB
            elsif func = "001" then
                ALUCTRL <= "001";
            end if;
          
        elsif ALUOp = "010" then  -- addi
                  ALUCTRL <= "010";  
        -- elsif ALUOp = "111" then  -- JUMP
       --     ALUCTRL <= "111";
        elsif ALUOp = "100" THEN -- beq
            ALUCTRL <= "100";
        elsif ALUOp = "101" then -- ble
             ALUCTRL <= "101";
        elsif ALUOp = "001" then -- noop
                          ALUCTRL <= "001";         
      --  else
        --     ALUCTRL <= "XXX";
        end if;
    end process;
    
     -- ALU
     
     process(ALUCTRL, RD1, ALUinput2, sa)
     begin
        if ALUCTRL = "000" THEN   -- sub
            ALUOut <= RD1 - ALUinput2;
                
            elsif ALUCTRL = "010" then  -- ADDI
                ALUout <=  RD1 + ALUinput2;
                
                elsif ALUCTRL = "100" then    -- beq
                    if RD1 = ALUinput2 then
                        ALUout <= x"0000";
                    else
                        ALUout <= x"0001";
                    end if;
                    
                    
                    elsif ALUCTRL = "101" then    -- ble 
                      
                        if RD1 > RD2 or  RD2(15) = '1' then
                            ALUout <= x"0000";  
                        else
                            ALUout <= x"0001";
                       end if;
                          elsif ALUCTRL = "001" then  -- NOOP
                            ALUOut <= RD1 - RD2;
                        
        end if;
       
        if ALUOut = x"0000" and ALUCTRL /= "001" and ALUinput2 /= X"0000"  then
           zero <= '1';
        elsif ALUOut = x"0000" and ALUCTRL = "101" then
            zero <= '1';
        else
            zero <= '0';
        end if;
        ALURes <= ALUOut;
     end process;
     
     
end Behavioral;