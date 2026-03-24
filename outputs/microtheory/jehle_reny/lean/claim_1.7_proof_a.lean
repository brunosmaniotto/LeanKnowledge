import Mathlib

open Topology
open BigOperators

/-- If u(x*) > u at a solution to the expenditure minimisation problem,
    then x* is not optimal: scaling down gives a cheaper feasible bundle.
    Hence the constraint must bind: u(x*) = u. -/
theorem Claim_1_7_proof_a
    {n : ℕ} (p x_star : Fin n → ℝ)
    (u_func : (Fin n → ℝ) → ℝ)
    (u_bar : ℝ)
    (hp : ∀ i, p i > 0)
    (hx_nn : ∀ i, x_star i ≥ 0)
    (h_feas : u_func x_star ≥ u_bar)
    (h_cost_pos : ∑ i, p i * x_star i > 0)
    -- Key economic hypothesis: if utility strictly exceeds u_bar,
    -- there exists t ∈ (0,1) such that scaling down remains feasible
    (h_binding_or_improvable :
      u_func x_star > u_bar →
      ∃ t : ℝ, 0 < t ∧ t < 1 ∧ u_func (fun i => t * x_star i) ≥ u_bar)
    -- x_star minimises cost among feasible bundles
    (h_opt : ∀ y : Fin n → ℝ, u_func y ≥ u_bar →
      ∑ i, p i * x_star i ≤ ∑ i, p i * y i) :
    u_func x_star = u_bar := by
  by_contra h_ne
  have h_strict : u_func x_star > u_bar := by
    cases lt_or_gt_of_ne h_ne with
    | inl h => linarith [h_feas]
    | inr h => exact h
  obtain ⟨t, ht_pos, ht_lt_one, ht_feas⟩ := h_binding_or_improvable h_strict
  have h_opt_t := h_opt (fun i => t * x_star i) ht_feas
  have h_cost_scaled : ∑ i, p i * (t * x_star i) = t * ∑ i, p i * x_star i := by
    simp [Finset.mul_sum, mul_comm, mul_assoc, mul_left_comm]
  linarith [mul_lt_of_lt_one_left (by linarith : (0 : ℝ) < ∑ i, p i * x_star i) ht_lt_one]