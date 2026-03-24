import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- When an outside agent 0 has transfer t₀(θ) = -Σ_{i≠0} tᵢ(θ), the total transfers
    sum to zero, achieving budget balance. This breaks the impossibility because
    agent 0 has no private information and absorbs the budget surplus/deficit. -/
theorem groves_budget_balance_with_outside_agent
    {n : ℕ} (hn : 0 < n)
    (t : Fin n → ℝ)
    (t₀ : ℝ)
    (h_t₀ : t₀ = -∑ i : Fin n, t i) :
    t₀ + ∑ i : Fin n, t i = 0 := by
  rw [h_t₀]
  linarith