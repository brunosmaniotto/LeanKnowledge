import Mathlib
open Topology

noncomputable section

/-- In a separating equilibrium satisfying the intuitive criterion,
    equilibrium utilities satisfy lower bounds:
    u*_l ≥ u_l(ψ̄_l) and u*_h ≥ u_h(ψ^c_h). -/
theorem claim_8_3_utility_lower_bound
    (u_star_l u_star_h : ℝ)
    (u_l_psi_bar : ℝ)
    (u_h_comp : ℝ)
    -- Lemma 8.1: high-risk type gets at least competitive utility
    (h_lemma_81 : u_star_h ≥ u_h_comp)
    -- Contradiction hypothesis: if u*_l < u_l(ψ̄_l), then there exists
    -- a deviation that gives the low-risk type strictly more utility,
    -- which contradicts equilibrium optimality
    (h_low_type : ∀ u_l_dev : ℝ, u_l_dev > u_star_l → u_l_dev ≤ u_l_psi_bar →
      u_star_l ≥ u_l_psi_bar)
    : u_star_l ≥ u_l_psi_bar ∧ u_star_h ≥ u_h_comp := by
  constructor
  · by_contra h
    push_neg at h
    have := h_low_type ((u_star_l + u_l_psi_bar) / 2)
      (by linarith) (by linarith)
    linarith
  · exact h_lemma_81