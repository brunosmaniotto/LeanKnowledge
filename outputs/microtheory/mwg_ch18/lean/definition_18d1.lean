import Mathlib

open scoped BigOperators

/-- A feasible allocation x* is self-selective (anonymous / envy-free in net trades)
if there exists a generalized budget set B ⊂ ℝ^L such that for every consumer i,
the net trade z*_i = x*_i − ω_i maximizes u_i(z_i + ω_i) subject to z_i ∈ B and
z_i + ω_i ≥ 0. -/
def IsSelfSelectiveAllocation
    (I : Type*) [Fintype I]
    (L : ℕ)
    (u : I → (Fin L → ℝ) → ℝ)
    (ω : I → (Fin L → ℝ))
    (x_star : I → (Fin L → ℝ)) : Prop :=
  ∃ B : Set (Fin L → ℝ),
    (∀ i : I, (fun l => x_star i l - ω i l) ∈ B) ∧
    (∀ i : I, ∀ l : Fin L, 0 ≤ x_star i l) ∧
    (∀ i : I, ∀ z ∈ B, (∀ l : Fin L, 0 ≤ z l + ω i l) →
      u i (fun l => z l + ω i l) ≤ u i (x_star i))