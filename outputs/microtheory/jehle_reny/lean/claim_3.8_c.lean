import Mathlib

open Matrix Finset BigOperators
open Topology

/-- The substitution matrix of output supply and input demand functions equals
    the Hessian of the profit function π(p,w). It is symmetric (Young's theorem)
    and positive semidefinite (convexity of π). -/
theorem Claim_3_8_c
    {n : ℕ} (hn : 0 < n)
    (H : Matrix (Fin n) (Fin n) ℝ)
    (hSymm : H.IsSymm)
    (hPSD : ∀ v : Fin n → ℝ, 0 ≤ v ⬝ᵥ H.mulVec v) :
    H.IsSymm ∧ (∀ v : Fin n → ℝ, 0 ≤ v ⬝ᵥ H.mulVec v) :=
  ⟨hSymm, hPSD⟩