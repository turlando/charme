module Syntax where

import Data.Text (Text)

data Literal = LiteralInteger Integer
             | LiteralString Text
             deriving (Eq, Show)
