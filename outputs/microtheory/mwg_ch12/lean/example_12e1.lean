import Mathlib

open Set

theorem Example_12E1
    (a c b : ℝ) (ha : a > c) (hc : c > 0) (hb : b > 0) :
    StrictAntiOn (fun J : ℝ => (a - c) ^ 2 / ((J + 1) ^ 2 * b)) (Set.Ici 0) := by
  intro J₁ hJ₁ J₂ _ hlt
  rw [Set.mem_Ici] at hJ₁
  have h1pos : J₁ + 1 > 0 := by linarith
  have h2pos : J₂ + 1 > 0 := by linarith
  have hac : (a - c) ^ 2 > 0 := by nlinarith
  have hd1 : (J₁ + 1) ^ 2 * b > 0 := by nlinarith [sq_nonneg (J₁ + 1), sq_abs (J₁ + 1)]
  have hd_lt : (J₁ + 1) ^ 2 * b < (J₂ + 1) ^ 2 * b := by nlinarith [sq_nonneg (J₁ + 1), sq_nonneg (J₂ + 1)]
  exact div_lt_div_of_pos_left hac hd1 hd_lt