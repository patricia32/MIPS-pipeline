----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/16/2022 06:39:15 PM
-- Design Name: 
-- Module Name: instructionFetch - Behavioral
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

entity IF_comp is
  Port ( jumpAddress: in STD_LOGIC_VECTOR(15 downto 0);
         branchAddress: in STD_LOGIC_VECTOR(15 downto 0);
         jump: in STD_LOGIC;
         PCsrc: in STD_LOGIC;
         clk: in STD_LOGIC;
         reset: in STD_LOGIC;
         enable: in STD_LOGIC;
         PC: out STD_LOGIC_VECTOR(15 downto 0);
         instruction: out STD_LOGIC_VECTOR(15 downto 0));
end IF_comp;

architecture Behavioral of IF_comp is
     signal pc_counter, NextAddress, PCAux, PCinc,  AuxSgn: STD_LOGIC_VECTOR(15 downto 0) := x"0000";
     type MEM is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
     signal ROM: MEM := (
        
        B"000_001_001_001_0_000",--     0 -- 0490 -- sub $1, $1, $1 
        B"000_100_100_100_0_000",--     1 -- 1240 -- sub $4, $4, $4 
        B"000_110_110_110_0_000",--    10 -- 1B60 -- sub $6, $6, $6  
        B"000_010_010_010_0_000",--    11 -- 0920 -- sub $2, $2, $2 
        B"000_011_011_011_0_000",--   100 -- 0DB0 -- sub $3, $3, $3 
        B"000_101_101_101_0_000",--   101 -- 16D0 -- sub $5, $5, $5 
        B"001_000_000_000_0_000",--   110 -- 0000 -- noop
        B"010_100_100_0001111",  --   111 -- 520F -- addi $4, $4, 15
        B"010_110_110_0000010",  --  1000 -- 5B02 -- addi $6, $6, 2 
        B"010_010_010_0001111",  --  1001 -- 490F -- addi $2, $2, 15   
        B"010_011_011_0000101",  --  1010 -- 4D85 -- addi $3, $3, 5
        B"010_101_101_0000101",  --  1011 -- 5685 -- addi $5, $5, 5
        B"001_000_000_000_0_000",--  1100 -- 0000 -- noop
        B"001_000_000_000_0_000",--  1101 -- 0000 -- noop
       
        B"000_100_110_100_0_000",--  1110 -- 1340 -- sub $4, $4, $6   - 11
        B"001_000_000_000_0_000",--  1111 -- 0000 -- noop
        B"001_000_000_000_0_000",-- 10000 -- 0000 -- noop                                                  
        B"001_000_000_000_0_000",-- 10001 -- 0000 -- noop
        B"100_001_100_0111000",  -- 10010 -- 8609 -- beq $4, $1, exitProgram
        B"001_000_000_000_0_000",-- 10011 -- 0000 -- noop
        B"001_000_000_000_0_000",-- 10100 -- 0000 -- noop
        B"001_000_000_000_0_000",-- 10101 -- 0000 -- noop
        B"101_001_100_0000101",  -- 10110 -- A606 -- ble $4, $1, loop2
        B"001_000_000_000_0_000",-- 10111 -- 0000 -- noop
        B"001_000_000_000_0_000",-- 11000 -- 0000 -- noop
        B"001_000_000_000_0_000",-- 11001 -- 0000 -- noop
        B"111_0000000001101",    -- 11010 -- E00D -- j loop1 
        B"001_000_000_000_0_000",-- 11011 -- 0001 -- noop
         
        B"000_101_110_101_0_000",-- 11100 -- 1750 -- sub $5, $5, $6    - 15
        B"001_000_000_000_0_000",-- 11101 -- 0000 -- noop
        B"001_000_000_000_0_000",-- 11110 -- 0000 -- noop                                                  
        B"001_000_000_000_0_000",-- 11111 -- 0000 -- noop
        B"100_001_101_011000",  --100000 -- 8687 -- beq $5, $1, exitProgram  
        B"001_000_000_000_0_000",--100001 -- 0000 -- noop
        B"001_000_000_000_0_000",--100010 -- 0000 -- noop                                                  
        B"001_000_000_000_0_000",--100011 -- 0000 -- noop
        B"101_001_101_0000101",  --100100 -- A681 -- ble $5, $1, loop3
        B"001_000_000_000_0_000",--100101 -- 0000 -- noop
        B"001_000_000_000_0_000",--100110 -- 0000 -- noop                                                  
        B"001_000_000_000_0_000",--100111 -- 0000 -- noop
        B"111_0000000011011",    --101000 -- E00F -- j loop2
       B"001_000_000_000_0_000",-- 101001 -- 0000 -- noop
       
        B"000_010_011_010_0_000",--101010 --  9A0 -- sub $2, $2, $3    - 19  
        B"001_000_000_000_0_000",--101011 -- 0000 -- noop
        B"001_000_000_000_0_000",--101100 -- 0000 -- noop                                                  
        B"001_000_000_000_0_000",--101101 -- 0000 -- noop
        B"100_001_010_0001001",  --101110 -- 8502 -- beq $2, $1, divizibile  
        B"001_000_000_000_0_000",--101111 -- 0000 -- noop
        B"001_000_000_000_0_000",--110000 -- 0000 -- noop                                                  
        B"001_000_000_000_0_000",--110001 -- 0000 -- noop 
        B"101_001_010_0000110",  --110010 -- A502 -- ble $2, $1, exitProgram  
        B"001_000_000_000_0_000",--110011 -- 0000 -- noop
        B"001_000_000_000_0_000",--110100 -- 0000 -- noop                                                  
        B"001_000_000_000_0_000",--110101 -- 0000 -- noop     
        B"111_0000000101001",    --110110 -- E013 -- j loop3
        B"001_000_000_000_0_000",--110111 -- 0000 -- noop
        
        B"010_001_001_0000001",  --111000 -- 4481 -- addi $1, $1, 1
               
        OTHERS => X"0000");
begin
    -- PROGRAM COUNTER
    process(clk)
    begin
      if reset = '1' then
                  pc_counter <= x"0000";
      end if;
        if rising_edge(clk) then 
             if enable = '1' then
                pc_counter <= NextAddress;
              end if ;
        end if;
    end process;
    
    Instruction <= ROM(conv_integer(pc_counter));
    
    PCAux <= pc_counter + 1;
    PCinc <= PCAux;
    
    
    -- mux branch
    process(PCsrc, PCAux, BranchAddress)
    begin
        if PCsrc = '0' then
             AuxSgn <= PCAux;
        else
            AuxSgn <= BranchAddress;
        end if;
    end process;
    
    
    -- mux jump
        process(Jump, AuxSgn, JumpAddress)
        begin
            if jump = '0' then 
                NextAddress <= AuxSgn;
            else
                NextAddress <= JumpAddress;
            end if;
        end process;
    PC <= pc_counter;
end Behavioral;
