import Mathlib
open Topology
open BigOperators

/-- The weak axiom of revealed preference (WA) for an excess demand function.
    An excess demand function z satisfies WA if for any pair of price vectors p and p',
    z(p) ≠ z(p') and p · z(p') ≤ 0 implies p' · z(p) > 0. -/
def SatisfiesWeakAxiomOfRevealedPreference {n : ℕ} (z : (Fin n → ℝ) → (Fin n → ℝ)) : Prop :=
  ∀ p p' : Fin n → ℝ,
    z p ≠ z p' →
    (∑ i, p i * z p' i) ≤ 0 →
    (∑ i, p' i * z p i) > 0