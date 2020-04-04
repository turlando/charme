module Parser where

import Import
import Ast (Ast (..))
import Text.Megaparsec
import Text.Megaparsec.Byte
import Control.Monad.Combinators
import qualified Control.Monad.Combinators.NonEmpty as NE
import Data.ByteString.Internal (c2w)

type Parser = Parsec Void ByteString
type Err = ParseErrorBundle ByteString Void

parse :: ByteString -> Either Err Ast
parse = runParser parser "filename"

parser :: Parser Ast
parser = parseSymbol
     <|> parseApp

parseSymbol :: Parser Ast
parseSymbol = fmap ASymbol $ chunk "foo"

parseApp :: Parser Ast
parseApp = do
  _ <- chunk "(" >> skipMany whitespace
  elems <- NE.some parser
  _ <- skipMany whitespace >> chunk ")"
  pure (AApp elems)

whitespace = let predicate c = c == (c2w ' ') -- || c == '\t' || c == '\n'
             in void (takeWhile1P Nothing predicate)
