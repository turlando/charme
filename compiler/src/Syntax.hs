module Syntax where

import Data.Text (Text)

data Expr = EAtom    Text
          | EInteger Integer
          | EString  Text
            deriving (Eq, Show)
