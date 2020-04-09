module ParserSpec (spec) where

import Parser
import Syntax
import Test.Hspec

spec :: Spec
spec = do
  describe "parse atoms" $ do
    it "can parse foo" $ do parse "foo" `shouldBe` Right (SyntaxAtom "foo")
    it "can parse BAR" $ do parse " BAR " `shouldBe` Right (SyntaxAtom "BAR")

  describe "parse integers without sign" $ do
    it "can parse a number" $ do
      parse "42" `shouldBe` Right (SyntaxInteger 42)
    it "can parse a number wrapped in spaces" $ do
      parse " 23 " `shouldBe` Right (SyntaxInteger 23)

  describe "parse integers with sign" $ do
    it "can parse a negative number" $ do
      parse "-42" `shouldBe` Right (SyntaxInteger (-42))
    it "can parse a negative number wrapped in spaces" $ do
      parse " -23 " `shouldBe` Right (SyntaxInteger (-23))

  describe "parse strings" $ do
    it "can parse \"foo\"" $ do
      parse "\"foo\"" `shouldBe` Right (SyntaxString "foo")
    it "can parse \"bar\"" $ do
      parse "\"bar\"" `shouldBe` Right (SyntaxString "bar")
    it "can parse \"\"qu\\\"ux\"" $ do
      parse "\"qu\\\"ux\"" `shouldBe` Right (SyntaxString "qu\"ux")

  describe "parse heterogeneous lists" $ do
    it "can parse (foo)" $ do
      parse "(foo)" `shouldBe` Right (SyntaxList [SyntaxAtom "foo"])
    it "can parse (foo \"bar\")" $ do
      parse "(foo \"bar\")" `shouldBe`
        Right (SyntaxList [SyntaxAtom "foo", SyntaxString "bar"])
    it "can parse (foo \"bar\" 23)" $ do
      parse "(foo \"bar\" 23)" `shouldBe`
        Right (SyntaxList [SyntaxAtom "foo", SyntaxString "bar", SyntaxInteger 23])
