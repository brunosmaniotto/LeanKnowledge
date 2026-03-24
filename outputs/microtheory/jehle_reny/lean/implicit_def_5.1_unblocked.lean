import Mathlib

open Finset BigOperators
open BigOperators

/-- An allocation `x` is unblocked if no coalition `S ⊆ I` can block it.
    A coalition blocks `x` when it can redistribute its own aggregate endowment
    among its members so that every member is strictly better off. -/
def IsUnblocked
    (I : Type*) [Fintype I] [DecidableEq I]
    (L : ℕ)
    (u : I → (Fin L → ℝ) → ℝ)
    (ω : I → Fin L → ℝ)
    (x : I → Fin L → ℝ) : Prop :=
  ¬ ∃ (S : Finset I), S.Nonempty ∧
    ∃ (y : I → Fin L → ℝ),
      (∀ l : Fin L, ∑ i ∈ S, y i l ≤ ∑ i ∈ S, ω i l) ∧
      (∀ i ∈ S, u i (y i) > u i (x i))