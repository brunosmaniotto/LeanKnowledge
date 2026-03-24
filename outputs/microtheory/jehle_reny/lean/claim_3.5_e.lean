import Mathlib

open BigOperators
open Topology

/-- Profit decomposition (MWG Claim 3.5): Problems (3.7) and (3.8) are equivalent.
    Given any input x and a cost-minimizer x* for output level f(x),
    the chain one_step(x) ≤ two_step(f(x)) ≤ one_step(x*) holds,
    proving the suprema of both formulations coincide. -/
theorem claim_3_5_e {n : ℕ} (p : ℝ) (w : Fin n → ℝ) (f : (Fin n → ℝ) → ℝ) (hp : 0 ≤ p)
    (x x_star : Fin n → ℝ)
    (hf : f x_star ≥ f x)
    (hc : ∑ i, w i * x_star i ≤ ∑ i, w i * x i) :
    p * f x - ∑ i, w i * x i ≤ p * f x - ∑ i, w i * x_star i ∧
    p * f x - ∑ i, w i * x_star i ≤ p * f x_star - ∑ i, w i * x_star i := by
  exact ⟨by linarith, by nlinarith⟩