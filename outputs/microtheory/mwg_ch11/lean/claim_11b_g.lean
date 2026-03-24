import Mathlib

open Real
open Topology

theorem Claim_11B_g (phi_2'_at_h_opt : ℝ) :
  (0 < phi_2'_at_h_opt) → (let t_h := -phi_2'_at_h_opt; t_h < 0) := by
  intro h_positive_externality
  -- We want to show that -phi_2'_at_h_opt < 0 given 0 < phi_2'_at_h_opt.
  -- This is a direct application of linear arithmetic.
  linarith