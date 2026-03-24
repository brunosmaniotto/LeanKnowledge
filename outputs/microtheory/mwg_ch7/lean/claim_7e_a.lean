import Mathlib
open Topology

theorem pure_strategy_is_degenerate_mixed_strategy
    {S : Type*} [DecidableEq S] (s : S) :
    ∃ (p : PMF S), p s = 1 ∧ ∀ t, t ≠ s → p t = 0 := by
  exact ⟨PMF.pure s, PMF.pure_apply_self s, fun t ht => by simp [PMF.pure_apply, ht]⟩