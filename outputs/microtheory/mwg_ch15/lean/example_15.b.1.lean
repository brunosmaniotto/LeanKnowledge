import Mathlib

/-- In an Edgeworth box economy with Cobb-Douglas utility u_i = x_{1i}^α · x_{2i}^{1-α},
    endowments ω₁ = (1,2) and ω₂ = (2,1), market clearing for good 1 implies
    p₁/p₂ = α/(1-α). -/
theorem Example_15_B_1
    (α p₁ p₂ : ℝ)
    (hα_pos : 0 < α) (hα_lt : α < 1)
    (hp₁ : 0 < p₁) (hp₂ : 0 < p₂)
    (h_clear : α * (p₁ + 2 * p₂) / p₁ + α * (2 * p₁ + p₂) / p₁ = 3) :
    p₁ / p₂ = α / (1 - α) := by
  have hα_ne : α ≠ 0 := ne_of_gt hα_pos
  have h1α_ne : (1 : ℝ) - α ≠ 0 := by linarith
  have hp₁_ne : p₁ ≠ 0 := ne_of_gt hp₁
  have hp₂_ne : p₂ ≠ 0 := ne_of_gt hp₂
  -- From h_clear: α * (p₁ + 2p₂ + 2p₁ + p₂) / p₁ = 3
  -- i.e., α * (3p₁ + 3p₂) / p₁ = 3
  -- i.e., α * (p₁ + p₂) = p₁
  -- i.e., α * p₂ = (1 - α) * p₁
  -- i.e., p₁ / p₂ = α / (1 - α)
  rw [div_eq_div_iff hp₂_ne h1α_ne]
  -- Goal: p₁ * (1 - α) = α * p₂
  -- From clearing condition, extract: α * (3p₁ + 3p₂) = 3 * p₁
  have key : α * (3 * p₁ + 3 * p₂) = 3 * p₁ := by
    have := h_clear
    rw [div_add_div_same, div_eq_iff hp₁_ne] at this
    linarith
  -- So 3α(p₁ + p₂) = 3p₁, hence α(p₁ + p₂) = p₁
  have key2 : α * (p₁ + p₂) = p₁ := by linarith
  -- Expand: αp₁ + αp₂ = p₁, so αp₂ = p₁ - αp₁ = (1-α)p₁
  nlinarith