module ParserSpec (spec) where

import Parser
import Syntax
import Test.Hspec

spec :: Spec
spec = do
  describe "parse integers without sign" $ do
    it "can parse 42" $ do parse "42" `shouldBe` Right (LiteralInteger 42)
    it "can parse 23" $ do parse "23" `shouldBe` Right (LiteralInteger 23)

  describe "parse integers with sign" $ do
    it "can parse -42" $ do parse "-42" `shouldBe` Right (LiteralInteger (-42))
    it "can parse -23" $ do parse "-23" `shouldBe` Right (LiteralInteger (-23))

  describe "parse strings" $ do
    it "can parse \"foo\"" $ do
      parse "\"foo\"" `shouldBe` Right (LiteralString "foo")
    it "can parse \"bar\"" $ do
      parse "\"bar\"" `shouldBe` Right (LiteralString "bar")
