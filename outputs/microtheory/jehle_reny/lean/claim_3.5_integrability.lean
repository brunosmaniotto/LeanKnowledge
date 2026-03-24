import Mathlib

open Matrix
open Topology

/-- Integrability for net supply: the supply substitution matrix Dy(p) is symmetric
    and positive semidefinite (PSD). This is the profit-maximization analog of the
    Slutsky matrix being symmetric and negative semidefinite (NSD) for consumer demand.
    Formally, if S is symmetric PSD, then −S is symmetric NSD. -/
theorem Claim_3_5_integrability
    {n : ℕ} (S : Matrix (Fin n) (Fin n) ℝ)
    (hS_symm : S.IsSymm)
    (hS_psd : ∀ x : Fin n → ℝ, 0 ≤ x ⬝ᵥ S.mulVec x) :
    (-S).IsSymm ∧ (∀ x : Fin n → ℝ, x ⬝ᵥ (-S).mulVec x ≤ 0) := by
  refine ⟨hS_symm.neg, fun x => ?_⟩
  simp only [neg_mulVec, dotProduct_neg]
  linarith [hS_psd x]