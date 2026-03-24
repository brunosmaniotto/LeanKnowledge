import Mathlib

noncomputable section

open Real

theorem Claim_Ex1_2_a (p₁ p₂ y t r : ℝ) (ht : t > 0)
    (hr : r ≠ 0) (hS : 0 < p₁ ^ r + p₂ ^ r)
    (hp₁ : p₁ > 0) (hp₂ : p₂ > 0) :
    let v := fun (q₁ q₂ w : ℝ) => w * (q₁ ^ r + q₂ ^ r) ^ (-(1 / r))
    v (t * p₁) (t * p₂) (t * y) = v p₁ p₂ y := by
  simp only
  have htge := le_of_lt ht
  have ht' := ne_of_gt ht
  have htr := rpow_pos_of_pos ht r
  rw [mul_rpow htge (le_of_lt hp₁), mul_rpow htge (le_of_lt hp₂),
      ← mul_add (t ^ r), mul_rpow (le_of_lt htr) (le_of_lt hS),
      ← rpow_mul htge]
  have hrr : r * (-(1 / r)) = -1 := by field_simp
  rw [hrr, rpow_neg htge, rpow_one,
      mul_mul_mul_comm, mul_inv_cancel₀ ht', one_mul]