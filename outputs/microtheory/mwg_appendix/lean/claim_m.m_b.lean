import Mathlib
open Topology

theorem Claim_M_M_b
    {n m : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) (b : Fin m → ℝ)
    (x₀ : Fin n → ℝ)
    (hfeas : ∀ i, (A.mulVec x₀) i ≤ b i)
    (d : Fin n → ℝ)
    (hd : ∀ i, (A.mulVec x₀) i = b i → (A.mulVec d) i ≤ 0) :
    ∃ ε > 0, ∀ t : ℝ, 0 ≤ t → t ≤ ε → ∀ i, (A.mulVec (x₀ + t • d)) i ≤ b i := by
  have hlin : ∀ (t : ℝ) (i : Fin m),
      (A.mulVec (x₀ + t • d)) i = A.mulVec x₀ i + t * A.mulVec d i := by
    intro t i
    simp only [Matrix.mulVec_add, Pi.add_apply, Matrix.mulVec_smul, Pi.smul_apply, smul_eq_mul]
  have hper : ∀ i : Fin m, ∃ εi > (0 : ℝ), ∀ t : ℝ, 0 ≤ t → t ≤ εi →
      A.mulVec x₀ i + t * A.mulVec d i ≤ b i := by
    intro i
    by_cases hAdi : A.mulVec d i ≤ 0
    · exact ⟨1, one_pos, fun t ht0 _ => by nlinarith [hfeas i]⟩
    · push_neg at hAdi
      have hlt : A.mulVec x₀ i < b i := by
        by_contra h; push_neg at h
        exact absurd (hd i (le_antisymm (hfeas i) h)) (not_le.mpr hAdi)
      refine ⟨(b i - A.mulVec x₀ i) / A.mulVec d i, div_pos (by linarith) hAdi, ?_⟩
      intro t ht0 htε
      have h1 : t * A.mulVec d i
          ≤ (b i - A.mulVec x₀ i) / A.mulVec d i * A.mulVec d i :=
        mul_le_mul_of_nonneg_right htε (le_of_lt hAdi)
      have h2 : (b i - A.mulVec x₀ i) / A.mulVec d i * A.mulVec d i
          = b i - A.mulVec x₀ i := by field_simp
      linarith
  by_cases hm : m = 0
  · subst hm; exact ⟨1, one_pos, fun _ _ _ i => i.elim0⟩
  · choose εi hεi_pos hεi using hper
    have hne : (Finset.univ : Finset (Fin m)).Nonempty :=
      Finset.univ_nonempty_iff.mpr ⟨⟨0, Nat.pos_of_ne_zero hm⟩⟩
    obtain ⟨j, _, hj⟩ := Finset.exists_min_image Finset.univ εi hne
    exact ⟨εi j, hεi_pos j, fun t ht0 htε i => by
      rw [hlin t i]
      exact hεi i t ht0 (le_trans htε (hj i (Finset.mem_univ i)))⟩