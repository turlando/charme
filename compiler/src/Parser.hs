module Parser where

import           Control.Applicative        ((<|>), empty)
import qualified Control.Monad.Combinators  as M
import           Data.Text                  (Text)
import qualified Data.Text                  as T
import           Data.Void                  (Void)
import           Syntax                     (Syntax (..))
import qualified Text.Megaparsec            as P
import qualified Text.Megaparsec.Char       as C
import qualified Text.Megaparsec.Char.Lexer as L

type Parser = P.Parsec Void Text
type Error  = P.ParseErrorBundle Text Void

-- A parser that can parse characters to be ignored,
-- including whitespaces and comments.
-- In this case C.space1 is parsing one or more space
-- characters; L.skipLineComment is parsing anything
-- starting with commentChar; block comments are not
-- implemented.
spaceConsumer :: Parser ()
spaceConsumer = L.space C.space1
                        (L.skipLineComment ";")
                        empty

-- Parser that matches text and picks up all trailing
-- white space.
symbol :: Text -> Parser Text
symbol = L.symbol spaceConsumer

parens :: Parser a -> Parser a
parens = M.between (symbol "(") (symbol ")")

atom :: Parser Text
atom = T.cons
       <$> C.letterChar
       <*> (fmap T.pack $ M.many C.alphaNumChar)

integer :: Parser Integer
integer = L.signed (pure ()) L.decimal

string :: Parser Text
string = fmap T.pack
         $ C.string "\""
         >> M.manyTill L.charLiteral (C.string "\"")

list :: Parser [Syntax]
list = parens $ M.sepBy syntax C.space1

syntax :: Parser Syntax
syntax = spaceConsumer
      >> fmap SyntaxAtom    atom
     <|> fmap SyntaxInteger integer
     <|> fmap SyntaxString  string
     <|> fmap SyntaxList    list

parse :: Text -> Either Error Syntax
parse = P.runParser syntax "filename"
