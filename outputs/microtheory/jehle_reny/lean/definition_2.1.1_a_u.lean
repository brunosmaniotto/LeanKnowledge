import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A(u) = ⋂_{p ≫ 0} A(p,u) = {x ∈ ℝⁿ₊ | p · x ≥ E(p, u) for all p ≫ 0} -/
noncomputable def A_u {n : ℕ} (E : (Fin n → ℝ) → ℝ → ℝ) (u : ℝ) : Set (Fin n → ℝ) :=
  {x | (∀ i, 0 ≤ x i) ∧ ∀ p : Fin n → ℝ, (∀ i, 0 < p i) → ∑ i, p i * x i ≥ E p u}