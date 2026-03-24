import Mathlib

open Finset BigOperators
open BigOperators

/-- An economy with I consumers, L goods, a production technology, and preferences. -/
structure Economy (I : Type*) (L : ℕ) [Fintype I] [DecidableEq I] where
  endowment : I → Fin L → ℝ
  endowment_nonneg : ∀ i k, 0 ≤ endowment i k
  pref : I → (Fin L → ℝ) → (Fin L → ℝ) → Prop
  technology : Set (Fin L → ℝ)
  tech_convex : Convex ℝ technology
  tech_zero : (0 : Fin L → ℝ) ∈ technology
  tech_constant_returns : ∀ y ∈ technology, ∀ (t : ℝ), 0 ≤ t → t • y ∈ technology

abbrev Allocation (I : Type*) (L : ℕ) := I → Fin L → ℝ

def Economy.IsFeasibleAllocation {I : Type*} {L : ℕ} [Fintype I] [DecidableEq I]
    (E : Economy I L) (x : Allocation I L) : Prop :=
  (∀ i k, 0 ≤ x i k) ∧
  ∃ y ∈ E.technology, ∀ k,
    ∑ i, x i k = y k + ∑ i, E.endowment i k