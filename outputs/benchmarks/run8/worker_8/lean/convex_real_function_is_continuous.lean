import Mathlib

open Set

theorem convex_on_interval_continuous {a b : ℝ} {f : ℝ → ℝ} (h : ConvexOn ℝ (Ioo a b) f) :
    ContinuousOn f (Ioo a b) :=
  h.continuousOn isOpen_Ioo