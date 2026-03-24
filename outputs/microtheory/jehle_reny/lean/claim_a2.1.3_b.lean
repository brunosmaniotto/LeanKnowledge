import Mathlib
open Topology

theorem Claim_A2_1_3_b
    {N : ℕ}
    (f : (Fin N → ℝ) → ℝ)
    (df : Fin N → (Fin N → ℝ) → ℝ)
    (x : Fin N → ℝ)
    (t : ℝ)
    (ht : t > 0)
    (i : Fin N)
    (hdf_hom : ∀ (s : ℝ), s > 0 → df i (s • x) = s ^ (0 : ℤ) * df i x) :
    df i (t • x) = df i x := by
  have h := hdf_hom t ht
  simp at h
  exact h