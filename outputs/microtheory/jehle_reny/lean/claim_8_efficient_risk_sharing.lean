import Mathlib

structure InsuranceSetup where
  u : ℝ → ℝ
  u_strict_concave : StrictConcaveOn ℝ Set.univ u
  B : ℝ → ℝ

def FullInsurance (B : ℝ → ℝ) : Prop := ∀ l : ℝ, B l = l