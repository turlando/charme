module Parser where

import           Control.Applicative        ((<|>), empty)
import qualified Control.Monad.Combinators  as M
import           Data.Text                  (Text)
import qualified Data.Text                  as Text
import           Data.Void                  (Void)
import           Syntax                     (Syntax (..))
import qualified Text.Megaparsec            as P
import qualified Text.Megaparsec.Char       as C
import qualified Text.Megaparsec.Char.Lexer as L

type Parser = P.Parsec Void Text
type Error  = P.ParseErrorBundle Text Void

commentString :: Text
commentString = ";"

stringEnclosingChar :: Char
stringEnclosingChar = '"'

-- A parser that can parse characters to be ignored,
-- including whitespaces and comments.
-- In this case C.space1 is parsing one or more space
-- characters; L.skipLineComment is parsing anything
-- starting with commentChar; block comments are not
-- implemented.
spaceConsumer :: Parser ()
spaceConsumer = L.space C.space1
                        (L.skipLineComment commentString)
                        empty

-- Wrapper that picks up all trailing white space
-- using the supplied space consumer.
lexeme :: Parser a -> Parser a
lexeme = L.lexeme spaceConsumer

atom :: Parser Text
atom = do
  first <- C.letterChar
  rest  <- fmap Text.pack $ M.many C.alphaNumChar
  return $ Text.cons first rest

integer :: Parser Integer
integer = lexeme L.decimal

signedInteger :: Parser Integer
signedInteger = L.signed (pure ()) integer

string :: Parser Text
string = fmap Text.pack
         $ C.char stringEnclosingChar
         *> M.manyTill L.charLiteral (C.char stringEnclosingChar)

syntax :: Parser Syntax
syntax = fmap SyntaxAtom    atom
     <|> fmap SyntaxInteger signedInteger
     <|> fmap SyntaxString  string

parse :: Text -> Either Error Syntax
parse = P.runParser syntax "filename"
