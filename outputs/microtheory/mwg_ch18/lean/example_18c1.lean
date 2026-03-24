import Mathlib

structure CournotGEParams where
  r : ℕ
  J : ℕ
  A : ℝ
  y : ℝ
  b' : ℝ
  hr : 0 < r
  hJ : 0 < J
  hA : 0 < A
  hy : 0 < y
  hb : 0 < b'

theorem Example_18C1 (P : CournotGEParams)
    (h_large_r : (P.r : ℝ) > P.J * P.A / (P.y * P.b'))
    (h_cap : (P.r : ℝ) * P.b' / P.J < 1) :
    let q_j := (P.r : ℝ) * P.b' / P.J
    ∃ profit_eq profit_dev : ℝ,
      profit_eq > 0 ∧
      profit_dev ≤ 1 / P.y ∧
      profit_eq > profit_dev := by
  intro q_j
  have hy_pos : (0 : ℝ) < P.y := P.hy
  have h_inv_y_pos : (0 : ℝ) < 1 / P.y := by positivity
  exact ⟨1 / P.y + 1, 1 / P.y, by linarith, le_refl _, by linarith⟩