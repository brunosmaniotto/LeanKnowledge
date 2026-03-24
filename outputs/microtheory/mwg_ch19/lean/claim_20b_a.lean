import Mathlib

/-- Time impatience from discounting: if δ < 1 and the discounted utility V(c) > 0
for a nonzero consumption stream c, then V(c) > V(c') where V(c') = δ · V(c)
is the utility of the forward-shifted stream. -/
theorem time_impatience_from_discounting
    (δ : ℝ) (Vc : ℝ)
    (hδ_pos : 0 < δ) (hδ_lt : δ < 1)
    (hVc_pos : 0 < Vc) :
    Vc > δ * Vc := by
  nlinarith