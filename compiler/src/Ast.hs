module Ast where

import Import

data Ast = AInteger Int
         | AString ByteString
         | AList [Ast]
         | ASymbol ByteString
         | ALambda [ByteString] Ast
         | AApp (NonEmpty Ast)
         | APlus Ast Ast
         | AMinus Ast Ast
         | AGreater Ast Ast
         | AIf Ast Ast Ast
         deriving (Show)
