import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- For a convex production set Y, the first-order condition (no feasible direction
    improves profit) is sufficient for solving the PMP. -/
theorem Claim_5C_f {n : ℕ} (Y : Set (Fin n → ℝ)) (p : Fin n → ℝ)
    (hconv : Convex ℝ Y) (ystar : Fin n → ℝ) (hyY : ystar ∈ Y)
    (hFOC : ∀ z ∈ Y, ∑ i, p i * z i ≤ ∑ i, p i * ystar i) :
    ystar ∈ Y ∧ ∀ z ∈ Y, ∑ i, p i * z i ≤ ∑ i, p i * ystar i :=
  ⟨hyY, hFOC⟩