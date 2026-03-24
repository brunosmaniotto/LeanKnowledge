import Mathlib

open Set

theorem image_interval_is_interval {I : Set ℝ} (hI : OrdConnected I) {f : ℝ → ℝ} (hf : ContinuousOn f I) :
    OrdConnected (f '' I) := by
  have hI_pre : IsPreconnected I := isPreconnected_iff_ordConnected.2 hI
  have h_img_pre : IsPreconnected (f '' I) := hI_pre.image f hf
  exact isPreconnected_iff_ordConnected.1 h_img_pre