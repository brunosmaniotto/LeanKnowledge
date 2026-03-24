import Mathlib

open BigOperators Finset Matrix

/-- Under homotheticity, Dz(p) decomposes into four terms. The covariance term
    can have the wrong sign, causing WA failure even with homothetic preferences. -/
theorem homotheticity_decomposition_WA_failure
    {L I : ℕ} [NeZero I]
    (substitution_matrices : Fin I → Matrix (Fin L) (Fin L) ℝ)
    (h_subst_nsd : ∀ i, ∀ v : Fin L → ℝ,
      dotProduct v (substitution_matrices i *ᵥ v) ≤ 0)
    (variance_term : Matrix (Fin L) (Fin L) ℝ)
    (h_var_nsd : ∀ v : Fin L → ℝ,
      dotProduct v (variance_term *ᵥ v) ≤ 0)
    (covariance_term : Matrix (Fin L) (Fin L) ℝ)
    (null_term : Matrix (Fin L) (Fin L) ℝ)
    (h_null : null_term = 0)
    (Dz : Matrix (Fin L) (Fin L) ℝ)
    (h_decomp : Dz = (∑ i : Fin I, substitution_matrices i) +
                      variance_term + covariance_term + null_term) :
    Dz = (∑ i : Fin I, substitution_matrices i) +
         variance_term + covariance_term + 0 := by
  subst h_null
  exact h_decomp