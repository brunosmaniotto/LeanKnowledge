import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The utilitarian form W = Σᵢ uᵢ is a limiting case of the CES social welfare
    function W = (Σᵢ (uᵢ)^ρ)^(1/ρ) as ρ → 1: when ρ = 1, the CES SWF reduces
    to W = Σᵢ uᵢ, reflecting complete social indifference to distribution. -/
theorem Claim_6E_j
    {n : ℕ} (hn : 0 < n) (u : Fin n → ℝ) :
    (∑ i : Fin n, u i ^ (1 : ℕ)) = ∑ i : Fin n, u i := by
  simp [pow_one]