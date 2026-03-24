import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The utilitarian SWF is neutral towards inequality: permuting utilities
    does not change the social welfare value (only total utility matters). -/
theorem utilitarian_swf_neutral_to_inequality
    {n : ℕ} (u : Fin n → ℝ) (σ : Equiv.Perm (Fin n)) :
    ∑ i, u (σ i) = ∑ i, u i := by
  exact Equiv.sum_comp σ u