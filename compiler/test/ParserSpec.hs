module ParserSpec (spec) where

import Data.Text             (Text, unpack)
import Parser                (parse)
import Syntax                (Syntax (..))
import Test.Hspec            (Spec, SpecWith, describe, it)
import Test.Hspec.Megaparsec (shouldParse, shouldFailOn)

canParse :: Text -> Syntax -> SpecWith ()
canParse from to = it ("can parse: " <> unpack from)
                   $ shouldParse (parse from) to

cantParse :: Text -> SpecWith ()
cantParse from = it ("can't parse: " <> unpack from)
                 $ shouldFailOn parse from

spec :: Spec
spec = do
  describe "literals" $ do

    describe "atoms" $ do
      canParse "foo" $ SyntaxAtom "foo"
      canParse "BAR" $ SyntaxAtom "BAR"
      canParse " foobar " $ SyntaxAtom "foobar"

    describe "unsigned integers" $ do
      canParse "42" $ SyntaxInteger 42
      canParse " 23 " $ SyntaxInteger 23

    describe "signed integers" $ do
      canParse "-42" $ SyntaxInteger (-42)
      canParse " -23 " $ SyntaxInteger (-23)
      cantParse "- 69420"

    describe "strings" $ do
      canParse "\"foo\"" $ SyntaxString "foo"
      canParse "\"bar\"" $ SyntaxString "bar"
      canParse "\"qu\\\"ux\"" $ SyntaxString "qu\"ux"

  describe "heterogeneous lists" $ do
    canParse "(foo)" $ SyntaxList [SyntaxAtom "foo"]
    canParse "(foo 23)" $ SyntaxList [SyntaxAtom "foo", SyntaxInteger 23]
    canParse "(foo \"bar\")" $ SyntaxList [SyntaxAtom "foo", SyntaxString "bar"]
