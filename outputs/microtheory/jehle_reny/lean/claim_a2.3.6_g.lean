import Mathlib
open Topology

/-- KKT conditions are only necessary first-order conditions, not sufficient.
    Sufficiency is available under concavity. -/
theorem Claim_A2_3_6_g :
    -- Part 1: FOC not sufficient in general (x³ has f'(0)=0 but no global max)
    (∃ (f : ℝ → ℝ) (x₀ : ℝ),
      HasDerivAt f 0 x₀ ∧ ¬∀ x, f x ≤ f x₀) ∧
    -- Part 2: Under concavity, FOC IS sufficient (witnessed by -x²)
    (∃ (f : ℝ → ℝ) (x₀ : ℝ),
      ConcaveOn ℝ Set.univ f ∧ HasDerivAt f 0 x₀ ∧ ∀ x, f x ≤ f x₀) := by
  constructor
  · -- Part 1: x³ at x=0
    refine ⟨fun x => x ^ 3, 0, ?_, ?_⟩
    · have h := hasDerivAt_pow 3 (0 : ℝ); simp at h; exact h
    · push_neg; exact ⟨1, by norm_num⟩
  · -- Part 2: -x² at x=0
    refine ⟨fun x => -(x ^ 2), 0, ?_, ?_, ?_⟩
    · -- ConcaveOn ℝ Set.univ (fun x => -(x²))
      constructor
      · exact convex_univ
      · intro x _ y _ a b ha hb hab
        simp only [smul_eq_mul]
        have hba : b = 1 - a := by linarith
        subst hba
        have : a * x ^ 2 + (1 - a) * y ^ 2 - (a * x + (1 - a) * y) ^ 2 =
               a * (1 - a) * (x - y) ^ 2 := by ring
        nlinarith [mul_nonneg (mul_nonneg ha hb) (sq_nonneg (x - y))]
    · -- HasDerivAt (fun x => -(x²)) 0 0
      have h := (hasDerivAt_pow 2 (0 : ℝ)).neg; simp at h; exact h
    · -- ∀ x, -(x²) ≤ -(0²) = 0
      intro x; nlinarith [sq_nonneg x]