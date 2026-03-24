import Mathlib

structure Technology where
  f : ℝ → ℝ

def IsModifiedGoldenRule (tech : Technology) (δ : ℝ) (k : ℝ) : Prop :=
  tech.f k * δ = 1

structure StationaryEquilibrium (tech : Technology) (δ : ℝ) where
  k : ℝ
  price_support : tech.f k * δ = 1