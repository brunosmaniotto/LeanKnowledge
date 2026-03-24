import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {n : ℕ}

/-- Inner product of two vectors over Fin n. -/
noncomputable def dotProd (v w : Fin n → ℝ) : ℝ :=
  ∑ i : Fin n, v i * w i

/-- The compensated law of demand: for any demand function satisfying cost minimization,
    if x is chosen at prices p and x' is chosen at prices p' with compensated wealth
    (so that p' · x ≥ w' and p · x' ≥ w), then (p' - p) · (x' - x) ≤ 0. -/
theorem compensated_law_of_demand
    (p p' x x' : Fin n → ℝ)
    (w w' : ℝ)
    (h_budget : dotProd p x ≤ w)
    (h_budget' : dotProd p' x' ≤ w')
    (h_comp1 : dotProd p' x ≥ w')   -- x was affordable at (p', w')
    (h_comp2 : dotProd p x' ≥ w)    -- x' was affordable at (p, w)
    : dotProd (fun i => p' i - p i) (fun i => x' i - x i) ≤ 0 := by
  unfold dotProd at *
  have h1 : ∑ i : Fin n, (p' i - p i) * (x' i - x i) =
    ∑ i : Fin n, (p' i * x' i - p' i * x i - p i * x' i + p i * x i) := by
    congr 1; ext i; ring
  rw [h1]
  have h2 : ∑ i : Fin n, (p' i * x' i - p' i * x i - p i * x' i + p i * x i) =
    (∑ i, p' i * x' i) - (∑ i, p' i * x i) - (∑ i, p i * x' i) + (∑ i, p i * x i) := by
    simp [Finset.sum_sub_distrib, Finset.sum_add_distrib]
  rw [h2]
  linarith