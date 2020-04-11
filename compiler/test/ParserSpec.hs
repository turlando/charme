module ParserSpec (spec) where

import Data.Text             (Text, unpack)
import Parser                (parse)
import Syntax                (Expr (..))
import Test.Hspec            (Spec, SpecWith, describe, it)
import Test.Hspec.Megaparsec (shouldParse, shouldFailOn)

canParse :: Text -> Expr -> SpecWith ()
canParse from to = it ("can parse: " <> unpack from)
                   $ shouldParse (parse from) to

cantParse :: Text -> SpecWith ()
cantParse from = it ("can't parse: " <> unpack from)
                 $ shouldFailOn parse from

spec :: Spec
spec = do
  describe "literals" $ do

    describe "atoms" $ do
      canParse "foo" $ EAtom "foo"
      canParse "BAR" $ EAtom "BAR"
      canParse " foobar " $ EAtom "foobar"

    describe "unsigned integers" $ do
      canParse "42" $ EInteger 42
      canParse " 23 " $ EInteger 23

    describe "signed integers" $ do
      canParse "-42" $ EInteger (-42)
      canParse " -23 " $ EInteger (-23)
      cantParse "- 69420"

    describe "strings" $ do
      canParse "\"foo\"" $ EString "foo"
      canParse "\"bar\"" $ EString "bar"
      canParse "\"qu\\\"ux\"" $ EString "qu\"ux"
