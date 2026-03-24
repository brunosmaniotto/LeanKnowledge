import Mathlib
open Topology

theorem adverse_selection_equilibrium
    (θ_lower : ℝ)
    (r : ℝ → ℝ)
    (h_lower : r θ_lower = θ_lower)
    (h_other : ∀ θ : ℝ, θ > θ_lower → r θ > θ_lower)
    (E_cond : ℝ → ℝ)
    (hE_at_lower : E_cond θ_lower = θ_lower)
    (hE_below : ∀ w : ℝ, w > θ_lower → E_cond w < w)
    (hE_above : ∀ w : ℝ, w < θ_lower → E_cond w ≥ θ_lower) :
    (∀ w : ℝ, E_cond w = w → w = θ_lower) := by
  intro w hw
  by_contra h
  rcases ne_iff_lt_or_gt.mp h with hlt | hgt
  · linarith [hE_above w hlt]
  · linarith [hE_below w hgt]