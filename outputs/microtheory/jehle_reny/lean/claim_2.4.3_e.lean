import Mathlib

theorem Claim_2_4_3_e (u' u'' : ℝ) (β : ℝ) (hβ : 0 < β) (hu' : u' ≠ 0) :
    -(β * u'') / (β * u') = -u'' / u' := by
  have hβ_ne : β ≠ 0 := ne_of_gt hβ
  field_simp