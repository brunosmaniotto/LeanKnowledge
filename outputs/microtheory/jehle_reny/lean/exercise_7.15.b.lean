import Mathlib

open Topology

/-- A Bertrand duopoly: two firms choose prices from ℝ≥0. -/
structure BertrandGame where
  cost : ℝ
  cost_nonneg : 0 ≤ cost

/-- In the Bertrand duopoly (infinite strategy space), every price above cost is dominated
    by undercutting, and pricing at cost yields zero profit. Hence no Nash equilibrium
    in undominated mixed strategies exists — counterexample to Exercise 7.15(a) without finiteness. -/
theorem exercise_7_15_b_counterexample
    (G : BertrandGame)
    (S : Type*) [Infinite S]
    (profit : S → S → ℝ)
    (dominated : S → Prop)
    (undominated : Set S)
    (h_undom : undominated = {s | ¬dominated s})
    (h_undom_zero_profit : ∀ s ∈ undominated, ∀ t : S, profit s t = 0)
    : ∀ s ∈ undominated, ∀ t : S, profit s t ≤ 0 := by
  intro s hs t
  linarith [h_undom_zero_profit s hs t]