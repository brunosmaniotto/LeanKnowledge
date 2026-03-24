import Mathlib

open BigOperators Finset Topology
open Topology

theorem Claim_3_5_c
    {n : ℕ}
    (p : ℝ)
    (w : Fin n → ℝ)
    (Df : Fin n → ℝ)  -- ∂f(x*)/∂x_i evaluated at x*
    (h_foc : ∀ i, p * Df i - w i = 0) :
    ∀ i, p * Df i = w i := by
  intro i
  linarith [h_foc i]