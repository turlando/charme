module Syntax where

import Data.Text (Text)

data Syntax = SyntaxAtom    Text
            | SyntaxInteger Integer
            | SyntaxString  Text
            deriving (Eq, Show)
