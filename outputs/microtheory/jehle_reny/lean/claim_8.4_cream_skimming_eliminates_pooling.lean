import Mathlib

theorem cream_skimming_eliminates_pooling
    (πL πH : ℝ)
    (hπL_pos : 0 < πL)
    (hπH_pos : 0 < πH)
    (hπ_order : πL < πH)
    (lam : ℝ)
    (hlam_pos : 0 < lam)
    (hlam_lt : lam < 1)
    (p_pool : ℝ)
    (hp_pool : p_pool = lam * πH + (1 - lam) * πL)
    (p_dev : ℝ)
    (hp_dev : p_dev = (πL + p_pool) / 2)
    (profit_dev : ℝ)
    (h_profit : profit_dev = p_dev - πL) :
    0 < profit_dev := by
  subst hp_pool; subst hp_dev; subst h_profit
  nlinarith