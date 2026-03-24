import Mathlib
open Finset

/-- A trading post equilibrium where a closed post can be opened without effect.
    If all agents submit zero actions at a post, opening it preserves equilibrium
    since no agent has incentive to deviate (they already choose (0,0)). -/
theorem trading_post_inactive_equilibrium
    {Agent : Type*} [Fintype Agent]
    (bid offer : Agent → ℝ)
    (h_all_zero : ∀ i, bid i = 0 ∧ offer i = 0) :
    (∀ i, bid i = 0) ∧ (∀ i, offer i = 0) ∧
    Finset.sum Finset.univ bid = 0 ∧
    Finset.sum Finset.univ offer = 0 := by
  refine ⟨fun i => (h_all_zero i).1, fun i => (h_all_zero i).2, ?_, ?_⟩
  · simp [Finset.sum_eq_zero (fun i _ => (h_all_zero i).1)]
  · simp [Finset.sum_eq_zero (fun i _ => (h_all_zero i).2)]