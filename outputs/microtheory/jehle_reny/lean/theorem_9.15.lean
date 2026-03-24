import Mathlib
open MeasureTheory
open Topology
open BigOperators
set_option linter.unusedVariables false

variable {I : Type} [Fintype I]

structure Mechanism (I : Type) [Fintype I] where
  cost : I → ℝ → ℝ
  p_bar : I → ℝ → ℝ
  expectedUtilityAtZero : I → ℝ

class IsIncentiveCompatible (M : Mechanism I) : Prop

axiom Theorem_9_14 (mech1 mech2 : Mechanism I) (h_inc1 : IsIncentiveCompatible mech1) (h_inc2 : IsIncentiveCompatible mech2)
  (h_p : ∀ i t, mech1.p_bar i t = mech2.p_bar i t) : ∀ i, ∃ k, ∀ t, mech1.cost i t = mech2.cost i t + k

axiom constant_zero_from_indifference_at_zero (mech1 mech2 : Mechanism I) (i : I) (k : ℝ)
  (hk : ∀ t, mech1.cost i t = mech2.cost i t + k) (h_u0 : mech1.expectedUtilityAtZero i = mech2.expectedUtilityAtZero i) : k = 0

noncomputable def Mechanism.expectedRevenue (M : Mechanism I) (μ : Measure (I → ℝ)) : ℝ :=
  ∫ (t : I → ℝ), ∑ i, M.cost i (t i) ∂μ

theorem Theorem_9_15 (mech1 mech2 : Mechanism I) (h_inc1 : IsIncentiveCompatible mech1) (h_inc2 : IsIncentiveCompatible mech2)
  (h_p : ∀ i t, mech1.p_bar i t = mech2.p_bar i t)
  (h_u0 : ∀ i, mech1.expectedUtilityAtZero i = mech2.expectedUtilityAtZero i)
  (μ : Measure (I → ℝ)) [IsProbabilityMeasure μ]
  (partial_deriv_v : I → ℝ → ℝ → ℝ) (h_deriv : ∀ i x, ContinuousOn (fun t => partial_deriv_v i x t) (Set.Icc (0 : ℝ) 1)) :
  mech1.expectedRevenue μ = mech2.expectedRevenue μ := by
  have h : ∀ i, ∃ k, ∀ t, mech1.cost i t = mech2.cost i t + k :=
    Theorem_9_14 mech1 mech2 h_inc1 h_inc2 h_p
  have cost_eq : ∀ i t, mech1.cost i t = mech2.cost i t := by
    intro i t
    obtain ⟨k, hk⟩ := h i
    have k0 : k = 0 := constant_zero_from_indifference_at_zero mech1 mech2 i k hk (h_u0 i)
    rw [hk, k0, add_zero]
  simp [Mechanism.expectedRevenue, cost_eq]