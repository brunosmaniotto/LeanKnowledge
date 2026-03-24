import Mathlib
open Topology

theorem myopic_profit_max_not_implies_efficiency :
    ∃ (consumption : ℕ → ℝ) (capital : ℕ → ℝ) (price : ℕ → ℝ),
      (∀ t, 0 < price t) ∧
      (∀ t, price (t + 1) > price t) ∧
      (∀ t, consumption t = 0) ∧
      (∃ (consumption' : ℕ → ℝ),
        (∀ t, consumption' t ≥ 0) ∧
        (∃ t₀, consumption' t₀ > 0)) := by
  refine ⟨fun _ => 0, fun _ => 1, fun t => (2 : ℝ) ^ (t : ℕ), ?_, ?_, ?_, ?_⟩
  · intro t; positivity
  · intro t
    show (2 : ℝ) ^ (t + 1) > (2 : ℝ) ^ t
    have h : (2 : ℝ) ^ t > 0 := by positivity
    nlinarith [pow_succ (2 : ℝ) t]
  · intro _; rfl
  · exact ⟨fun _ => 1, fun _ => by norm_num, ⟨0, one_pos⟩⟩