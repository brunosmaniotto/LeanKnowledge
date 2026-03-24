import Mathlib

theorem cost_min_mrts_eq_price_ratio
    (dfi dfj wi wj lam : ℝ)
    (hlam : lam ≠ 0)
    (hdfj : dfj ≠ 0)
    (hwj : wj ≠ 0)
    (hfoc_i : wi = lam * dfi)
    (hfoc_j : wj = lam * dfj) :
    dfi / dfj = wi / wj := by
  rw [hfoc_i, hfoc_j]
  rw [mul_div_mul_left _ _ hlam]