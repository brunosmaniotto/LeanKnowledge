import Mathlib

open Real

theorem has_deriv_at_neg_cos_add_const (x : ℝ) (C : ℝ) :
    HasDerivAt (fun t => -cos t + C) (sin x) x := by
  have h : HasDerivAt cos (-sin x) x := hasDerivAt_cos x
  have h_neg : HasDerivAt (fun t => -cos t) (-(-sin x)) x := HasDerivAt.neg h
  simp only [neg_neg] at h_neg
  exact h_neg.add_const C