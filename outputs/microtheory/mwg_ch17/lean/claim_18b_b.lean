import Mathlib

namespace Claim18Bb

variable {I : Type*} [Fintype I] [Nonempty I]

structure Economy (I : Type*) where
  pref : I → (I → ℝ) → (I → ℝ) → Prop
  feasible : Set (I → ℝ)
  endowment : I → ℝ

def ParetoOptimal (E : Economy I) (x : I → ℝ) : Prop :=
  ¬∃ y ∈ E.feasible, (∀ i : I, E.pref i x y ∨ x i = y i) ∧ (∃ i : I, E.pref i x y)