module Assembly where

import           Data.Text (Text)
import qualified Data.Text as T

-- 16 registers, represented with 4 bits
data Reg = R0  | R1  | R2  | R3 | R4
         | R5  | R6  | R7  | R8 | R9
         | R10 | R11 | R12
         | SP  | LR  | PC
         deriving (Eq, Show)

-- Immediate constant, 12 bits
type Imm = Int

data Instruction = IAddReg Reg Reg Reg
                 | IAddImm Reg Reg Imm
                 | IMovReg Reg Reg
                 | IMovImm Reg Imm
                 deriving (Eq, Show)

reg :: Reg -> Text
reg r = T.toLower $ T.pack $ show r

imm :: Imm -> Text
imm i = T.pack $ show i

instruction :: Instruction -> Text
instruction (IAddReg d m n) = "add " <> reg d <> ", " <> reg m <> ", " <> reg n
instruction (IAddImm d m n) = "add " <> reg d <> ", " <> reg m <> ", " <> "#" <> imm n
instruction (IMovReg d m)   = "mov " <> reg d <> ", " <> reg m
instruction (IMovImm d m)   = "mov " <> reg d <> ", " <> "#" <> imm m
