import Mathlib

open BigOperators Finset Topology Set
open Topology

-- Re-declaring the structure for context.
structure Assn_5_1_ConsumerUtility {n : ℕ} (u : (Fin n → ℝ) → ℝ) where
  continuous_on_rn_plus : ContinuousOn u (pi univ (fun _ => Ici 0))
  strongly_increasing : ∀ x y : Fin n → ℝ, (∀ k, x k ≤ y k) → (∃ j, x j < y j) → u x < u y
  strictly_quasiconcave : ∀ x y : Fin n → ℝ, (u x ≤ u y) → (x ≠ y) → ∀ t ∈ Ioo (0:ℝ) 1, u x < u (t • x + (1-t) • y)

-- Re-declaring the definition for context.
def ConsumerBudgetSet {n : ℕ} (p e : Fin n → ℝ) : Set (Fin n → ℝ) :=
  {x | (∀ k, 0 ≤ x k) ∧ ∑ k, p k * x k ≤ ∑ k, p k * e k}

-- Theorem declaration