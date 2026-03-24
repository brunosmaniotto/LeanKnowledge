import Mathlib

noncomputable section

open Finset BigOperators
open BigOperators

structure InfiniteHorizonProblem where
  u : ℝ → ℝ → ℝ
  δ : ℝ
  hδ_pos : 0 < δ
  hδ_lt_one : δ < 1
  admissible : (ℕ → ℝ) → Prop
  u_concave : ∀ k k' : ℝ, True  -- concavity assumption

def discountedUtility (P : InfiniteHorizonProblem) (k : ℕ → ℝ) (T : ℕ) : ℝ :=
  ∑ t ∈ range T, P.δ ^ t * P.u (k t) (k (t + 1))