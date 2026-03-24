import Mathlib

noncomputable def forcingContract {Effort Profit : Type} [DecidableEq Profit]
    (π_fn : Effort → Profit) (w_bar penalty : ℝ) (e_bar : Effort) (π_observed : Profit) : ℝ :=
  if π_observed = π_fn e_bar then w_bar else penalty

theorem Claim_14D_b {Effort Profit : Type} [DecidableEq Profit]
    (π_fn : Effort → Profit) (w_bar penalty : ℝ) (e_bar : Effort) :
    forcingContract π_fn w_bar penalty e_bar (π_fn e_bar) = w_bar := by
  simp [forcingContract]