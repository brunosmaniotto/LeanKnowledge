import Mathlib

theorem marginal_rate_of_transformation
    (dF_ℓ dF_k dy_ℓ dy_k : ℝ)
    (hk_ne : dF_k ≠ 0)
    (hl_ne : dy_ℓ ≠ 0)
    (total_diff : dF_ℓ * dy_ℓ + dF_k * dy_k = 0) :
    dy_k / dy_ℓ = -(dF_ℓ / dF_k) := by
  have h1 : dF_k * dy_k = -(dF_ℓ * dy_ℓ) := by linarith
  have h2 : dy_k = -(dF_ℓ * dy_ℓ) / dF_k := by
    field_simp
    linarith
  rw [h2]
  field_simp