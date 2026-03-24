import Mathlib
open Finset BigOperators
open Topology
open BigOperators

structure SimpleGamble (n : ℕ) where
  prob : Fin n → ℝ
  wealth : Fin n → ℝ
  prob_nonneg : ∀ i, 0 ≤ prob i
  wealth_nonneg : ∀ i, 0 ≤ wealth i
  prob_sum : ∑ i, prob i = 1

noncomputable def SimpleGamble.expectedValue {n : ℕ} (g : SimpleGamble n) : ℝ :=
  ∑ i, g.prob i * g.wealth i

noncomputable def SimpleGamble.expectedUtility {n : ℕ} (u : ℝ → ℝ) (g : SimpleGamble n) : ℝ :=
  ∑ i, g.prob i * u (g.wealth i)

def SimpleGamble.IsNonDegenerate {n : ℕ} (g : SimpleGamble n) : Prop :=
  ∃ i j, i ≠ j ∧ 0 < g.prob i ∧ 0 < g.prob j ∧ g.wealth i ≠ g.wealth j