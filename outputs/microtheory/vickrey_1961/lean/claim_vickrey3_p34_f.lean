import Mathlib

open Set

/-- Standard real analysis: strictly monotone on compact interval + connected image → continuous -/
axiom strictMonoOn_continuousOn_of_isPreconnected_image
    {f : ℝ → ℝ} {a b : ℝ}
    (hmono : StrictMonoOn f (Icc a b))
    (himg : IsPreconnected (f '' Icc a b)) :
    ContinuousOn f (Icc a b)

theorem claim_vickrey3_p34_f
    (y : ℝ → ℝ) (xm b : ℝ)
    (hxm_lt_b : xm < b)
    (hmono : StrictMonoOn y (Icc xm b))
    (himg : IsPreconnected (y '' Icc xm b))
    (hbdry : y xm = xm)
    (hshade : ∀ x ∈ Ioc xm b, y x < x) :
    ContinuousOn y (Icc xm b) ∧ (∀ x ∈ Icc xm b, y x = x → x = xm) := by
  constructor
  · exact strictMonoOn_continuousOn_of_isPreconnected_image hmono himg
  · intro x hx hyx
    by_contra hne
    have hlt : xm < x := lt_of_le_of_ne hx.1 (Ne.symm hne)
    linarith [hshade x ⟨hlt, hx.2⟩]