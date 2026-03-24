import Mathlib

open Finset BigOperators
open BigOperators

structure IndivisibleGoodOutcome (I : ℕ) where
  y : Fin I → Fin 2
  t : Fin I → ℝ

def IndivisibleGoodOutcome.feasible {I : ℕ} (x : IndivisibleGoodOutcome I) : Prop :=
  (∑ i : Fin I, (x.y i).val) = 1 ∧ (∑ i : Fin I, x.t i) ≤ 0

noncomputable def agentUtility {I : ℕ} (θ m : Fin I → ℝ)
    (x : IndivisibleGoodOutcome I) (i : Fin I) : ℝ :=
  θ i * (x.y i).val + (m i + x.t i)