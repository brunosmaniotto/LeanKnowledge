import Mathlib

open Matrix Finset BigOperators
open Topology
open BigOperators

/-- If each Sᵢ is negative semidefinite on a subspace, and C = Σᵢ Sᵢ - S is positive
    semidefinite, then S is negative semidefinite on that subspace.
    This is the core linear-algebra lemma behind Claim 4.C(ii) in MWG. -/
theorem aggregate_slutsky_neg_semidef
    {n : ℕ} {I : Finset ι}
    (S : Matrix (Fin n) (Fin n) ℝ)
    (Si : ι → Matrix (Fin n) (Fin n) ℝ)
    (C : Matrix (Fin n) (Fin n) ℝ)
    (hC_def : C = ∑ i ∈ I, Si i - S)
    (hSi_neg : ∀ i ∈ I, ∀ v : Fin n → ℝ, v ⬝ᵥ (Si i).mulVec v ≤ 0)
    (hC_psd : ∀ v : Fin n → ℝ, 0 ≤ v ⬝ᵥ C.mulVec v) :
    ∀ v : Fin n → ℝ, v ⬝ᵥ S.mulVec v ≤ 0 := by
  intro v
  have hC_v := hC_psd v
  rw [hC_def] at hC_v
  simp only [sub_mulVec, dotProduct_sub] at hC_v
  -- hC_v : 0 ≤ v ⬝ᵥ (∑ i ∈ I, Si i).mulVec v - v ⬝ᵥ S.mulVec v
  -- So v ⬝ᵥ S.mulVec v ≤ v ⬝ᵥ (∑ i ∈ I, Si i).mulVec v
  have hsum_neg : v ⬝ᵥ (∑ i ∈ I, Si i).mulVec v ≤ 0 := by
    simp only [sum_mulVec, dotProduct_sum]
    exact sum_nonpos fun i hi => hSi_neg i hi v
  linarith