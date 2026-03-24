import Mathlib

open BigOperators Finset
open Topology

/-- Market demand (sum of individual demands) depends on all prices:
    if changing a parameter affects some buyer's demand while leaving others unchanged,
    then market demand also changes. -/
theorem Claim_4_1_a {I : ℕ}
    (d : Fin I → ℝ → ℝ)
    (t t' : ℝ)
    (i₀ : Fin I)
    (h_sens : d i₀ t ≠ d i₀ t')
    (h_others : ∀ i, i ≠ i₀ → d i t = d i t') :
    (∑ i : Fin I, d i t) ≠ (∑ i : Fin I, d i t') := by
  intro h_eq
  apply h_sens
  have h1 : ∑ i : Fin I, (d i t - d i t') = 0 := by
    rw [Finset.sum_sub_distrib]; linarith
  have h2 : ∑ i : Fin I, (d i t - d i t') = d i₀ t - d i₀ t' := by
    apply Finset.sum_eq_single i₀
    · intro b _ hb; simp [h_others b hb]
    · intro h; exact absurd (mem_univ i₀) h
  linarith