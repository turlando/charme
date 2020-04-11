module AssemblySpec (spec) where

import Assembly        (Reg (..), Instruction (..), instruction)
import Test.Hspec      (Spec, describe, it, shouldBe)

spec :: Spec
spec = do
  describe "add" $ do
    it "can add registers" $ do
      instruction (IAddReg R0 R1 R2) `shouldBe` "add r0, r1, r2"
    it "can add immediate" $ do
      instruction (IAddImm R0 R1 42) `shouldBe` "add r0, r1, #42"
  describe "mov" $ do
    it "can mov registers" $ do
      instruction (IMovReg R0 R1) `shouldBe` "mov r0, r1"
    it "can mov immediate" $ do
      instruction (IMovImm R0 23) `shouldBe` "mov r0, #23"
