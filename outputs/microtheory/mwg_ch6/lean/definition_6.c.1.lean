import Mathlib

structure LotteryPrefs (L : Type*) where
  pref : L → L → Prop
  degenerate : ℝ → L
  expectedValue : L → ℝ

def RiskAverse {L : Type*} (P : LotteryPrefs L) : Prop :=
  ∀ F : L, P.pref (P.degenerate (P.expectedValue F)) F