----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2022 01:00:01 PM
-- Design Name: 
-- Module Name: test_env_main - Behavioral
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

entity test_env_main is
   Port ( clk : in STD_LOGIC;
          btn : in STD_LOGIC_VECTOR (4 downto 0);
          sw : in STD_LOGIC_VECTOR (15 downto 0);
          led : out STD_LOGIC_VECTOR (15 downto 0);
          an : out STD_LOGIC_VECTOR (3 downto 0);
          cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env_main;

architecture Behavioral of test_env_main is
 component MPG
   port(btn: in STD_LOGIC;
       clock: in STD_LOGIC;
       en: out STD_LOGIC);
 end component;
 
  component SSD
    port( digits : in STD_LOGIC_VECTOR (15 downto 0);
          clk : in STD_LOGIC;
          cat : out STD_LOGIC_VECTOR (6 downto 0);
          an : out STD_LOGIC_VECTOR (3 downto 0));
  end component;
  
  component IF_comp is
    Port ( jumpAddress: in STD_LOGIC_VECTOR(15 downto 0);
           branchAddress: in STD_LOGIC_VECTOR(15 downto 0);
           jump: in STD_LOGIC;
           PCsrc: in STD_LOGIC;
           clk: in STD_LOGIC;
           reset: in STD_LOGIC;
           enable: in STD_LOGIC;
           PC: out STD_LOGIC_VECTOR(15 downto 0);
           instruction: out STD_LOGIC_VECTOR(15 downto 0));
  end component;
  
  component ID_comp is
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
  end component;
  
  component EX_comp is
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
  end component;
  
  component MEM_comp is
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
             enable : in STD_LOGIC;
             clk : in STD_LOGIC);
  end component;
  
  component MainUnit is
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
  end component;

      signal enable, resetEnable, MemToReg, Branch, RegWrite, RegDst, RegOp, sa, ALUSrc, Zero, MemWrite, PCSrc , Jump, ExtOp, zr, br: STD_LOGIC;
      signal digits, JumpAddress, PCcounter, instruction, WriteData, RD1, RD2, Ext_Imm, ext_func, ext_sa, BranchAddress, ALURes, ALUResOut,  MemData:  STD_LOGIC_VECTOR(15  DOWNTO 0); 
      signal func,  ALUOp, rt, rd, rWA:  STD_LOGIC_VECTOR(2  DOWNTO 0);
      
    -- pipeline registers
    -- IF_ID
      signal PCinc_IF_ID, Instruction_IF_ID: STD_LOGIC_VECTOR(15  DOWNTO 0);
    -- ID_EX
      signal PCinc_ID_EX, RD1_ID_EX, RD2_ID_EX, EXT_IMM_ID_EX:  STD_LOGIC_VECTOR(15  DOWNTO 0);
      signal func_ID_EX, rt_ID_EX, rd_ID_EX, ALUOp_ID_EX:  STD_LOGIC_VECTOR(2 DOWNTO 0);
      signal sa_ID_EX, RegDst_ID_EX, MemtoReg_ID_EX, RegWrite_ID_EX, MemWrite_ID_EX, Branch_ID_EX, ALUSrc_ID_EX, Branch_F, PCSrc1: STD_LOGIC;
    -- EX_MEM 
      signal BranchAddress_EX_MEM, ALURes_EX_MEM, RD2_EX_MEM: STD_LOGIC_VECTOR(15  DOWNTO 0);
      signal rd_EX_MEM: STD_LOGIC_VECTOR(2  DOWNTO 0);
      signal zero_EX_MEM, MemtoReg_EX_MEM, RegWrite_EX_MEM, MemWrite_EX_MEM, Branch_EX_MEM: STD_LOGIC;
    -- MEM_WB
      signal MemData_MEM_WB, ALURes_MEM_WB:  STD_LOGIC_VECTOR(15  DOWNTO 0);
      signal rd_MEM_WB:  STD_LOGIC_VECTOR(2  DOWNTO 0);
      signal MemtoReg_MEM_WB, RegWrite_MEM_WB:  STD_LOGIC; 
begin

        MPG1portmap: MPG port map(btn(0), clk, enable);
        MPG2portmap: MPG port map(btn(1), clk, resetEnable);
        
        IFportmap: IF_comp port map(JumpAddress, BranchAddress_EX_MEM, Jump, PCSrc, clk, resetEnable, enable, PCcounter, instruction);
        IDportmap: ID_comp port map(clk, enable, instruction_IF_ID(12 downto 0), WriteData, rd_MEM_WB, RegWrite_MEM_WB, RegOp, RD1, RD2, Ext_Imm, func, sa, rt, rd );
        MainUnitportmap: MainUnit port map(Instruction(15 downto 13), RegDst, RegOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemToReg, RegWrite);
        EXportmap: EX_comp port map(PCinc_ID_EX, RD1_ID_EX, RD2_ID_EX, EXT_IMM_ID_EX, ALUSrc_ID_EX, Branch, RegDst_ID_EX, ALUOp_ID_EX,  rt_ID_EX, rd_ID_EX, sa_ID_EX, func_ID_EX, BranchAddress, ALURes, rWA, Zero, Branch);
        MEMportmap: MEM_comp port map( rWA, Zero_EX_MEM, Branch_ID_EX, MemWrite_EX_MEM, ALURes_EX_MEM, RD2_EX_MEM, MemData, ALUResOut, rd_EX_MEM, Branch, enable, clk);
     
         process(MemToReg, ALURes, MemData, PCcounter)
           begin
               if MemToReg = '0' then
                   WriteData <= ALUResOut;
               else
                   WriteData <= MemData;
               end if;
           end process;
       
       -- BRANCH
           PCSrc <= Branch_EX_MEM and Zero_EX_MEM;   
       -- JUMP
           JumpAddress <= PCinc_IF_ID(15 downto 13) & Instruction(12 downto 0);
         
         -- ssd
         with sw(14 downto 12) select
             digits  <= instruction when "000",
             rd1 when "001",
             rd2  when "010",
             RD2_ID_EX  when "011",
             pcCounter when "100",
             BranchAddress_EX_MEM when "101",
             RD1_ID_EX  when "110",
             EXT_IMM_ID_EX when "111",
             (others => 'X') when others;
                  
        process(clk)
        begin
            if rising_edge(clk) then
                if enable = '1' then
                    --IF_ID
                    PCinc_IF_ID <= PCcounter;
                    Instruction_IF_ID <= Instruction; 
                    -- ID_EX
                    PCinc_ID_EX <= PCinc_IF_ID;
                    RD1_ID_EX <= RD1;
                    RD2_ID_EX <= RD2;
                    EXT_IMM_ID_EX <= EXT_IMM;
                    sa_ID_EX <= sa;
                    func_ID_EX <= func;
                    rt_ID_EX <= rt; -- Instruction(9 to 7);
                    rd_ID_EX <= rd; -- Instruction(6 to 4);
                    MemtoReg_ID_EX <= MemtoReg;
                    RegWrite_ID_EX <= RegWrite;
                    MemWrite_ID_EX <= MemWrite;
                    Branch_ID_EX <= Branch;
                    ALUSrc_ID_EX <= ALUSrc;
                    ALUOp_ID_EX <= ALUOp; 
                    RegDst_ID_EX <= RegDst;
                    -- EX_MEM
                    BranchAddress_EX_MEM <= BranchAddress;
                    Zero_EX_MEM <= Zero;
                    ALURes_EX_MEM <= ALURes;
                    RD2_EX_MEM <= RD2_ID_EX;
               --     rd_EX_MEM <= rWA;
                    MemtoReg_EX_MEM <= MemtoReg_ID_EX;
                    RegWrite_EX_MEM <= RegWrite_ID_EX;
                    MemWrite_EX_MEM <= MemWrite_ID_EX;
                    Branch_EX_MEM <= Branch_ID_EX;  
               
                    -- MEM_WB
                    MemData_MEM_WB <= MemData;
                    ALURes_MEM_WB <= ALUResOut;
                    rd_MEM_WB <= rd_EX_MEM;
                    MemtoReg_MEM_WB <= MemtoReg_EX_MEM;
                    RegWrite_MEM_WB <= RegWrite_EX_MEM;       
                    PCSrc1 <= PCSrc;          
                end if;
            end if;
        end process;
         
         SSDportmap: SSD port map(digits, clk, cat, an);
    
        led(9 downto 0) <= PCSrc1 & PCSrc & ALUOp & RegDst & ALUSrc & Branch_ID_EX & Zero & Branch; 

end Behavioral;
