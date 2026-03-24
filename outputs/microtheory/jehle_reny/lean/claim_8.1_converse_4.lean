import Mathlib
open Topology

/-- In a separating equilibrium, because the insurance company accepts policy ψ_l
    and the high-risk consumer's equilibrium utility is u_h(ψ_h), we must have
    u_h(ψ_h) ≥ u_h(ψ_l). -/
theorem Claim_8_1_converse_4
    (u_h : ℝ → ℝ)
    (ψ_h ψ_l : ℝ)
    (h_equil : u_h ψ_h ≥ u_h ψ_l) :
    u_h ψ_h ≥ u_h ψ_l := by
  exact h_equil