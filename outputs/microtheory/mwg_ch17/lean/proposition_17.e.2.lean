import Mathlib

open Matrix Finset BigOperators
open Topology
open BigOperators

theorem Proposition_17_E_2
    {L : ℕ} [NeZero L]
    (p z : Fin L → ℝ)
    (A : Matrix (Fin L) (Fin L) ℝ)
    (hpz : ∑ i, p i * z i = 0)
    (hAp : A.mulVec p = 0)
    (hpA : vecMul p A = -z) :
    ((-Aᵀ).mulVec p = z) ∧ (A.mulVec p = 0) := by
  refine ⟨?_, hAp⟩
  ext j
  simp only [mulVec, dotProduct, transpose_apply, neg_apply, neg_mul]
  have h := congr_fun hpA j
  simp only [vecMul, dotProduct, Pi.neg_apply] at h
  -- h : ∑ x, p x * A x j = -z j
  -- goal : ∑ x, -(A x j * p x) = z j
  have key : ∑ x : Fin L, -(A x j * p x) = -∑ x : Fin L, A x j * p x := by
    rw [← Finset.sum_neg_distrib]
  rw [key]
  have : ∑ x : Fin L, A x j * p x = ∑ x : Fin L, p x * A x j :=
    Finset.sum_congr rfl (fun x _ => mul_comm (A x j) (p x))
  linarith