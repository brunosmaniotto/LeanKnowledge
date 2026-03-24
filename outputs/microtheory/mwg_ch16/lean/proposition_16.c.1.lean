import Mathlib

open Finset BigOperators
open BigOperators

theorem Proposition_16C1_First_Welfare_Theorem
    {I J : Type*} [Fintype I] [Fintype J] [DecidableEq I]
    (w : I → ℝ)
    (cost : I → ℝ)
    (profit : J → ℝ)
    (profitStar : J → ℝ)
    (omega : ℝ)
    (pref_strict : I → Prop)
    (h_strict : ∀ i, pref_strict i → cost i > w i)
    (h_weak : ∀ i, cost i ≥ w i)
    (h_some_strict : ∃ i, pref_strict i)
    (h_profit_max : ∀ j, profitStar j ≥ profit j)
    (h_wealth : ∑ i, w i = omega + ∑ j, profitStar j)
    (h_feasible : ∑ i, cost i = omega + ∑ j, profit j) :
    False := by
  obtain ⟨i₀, hi₀⟩ := h_some_strict
  have h_sum_gt : ∑ i, cost i > ∑ i, w i :=
    sum_lt_sum (fun i _ => h_weak i) ⟨i₀, mem_univ _, h_strict i₀ hi₀⟩
  have h_profit_sum : ∑ j, profitStar j ≥ ∑ j, profit j :=
    sum_le_sum fun j _ => h_profit_max j
  linarith