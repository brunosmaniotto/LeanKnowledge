import Mathlib

open Metric
open Topology

/-- Axiom 4' (Local Non-satiation) rules out zones of indifference:
    there cannot exist an open ball around any point x such that every
    point in that ball is indifferent to x. -/
theorem claim_1_2_i
    {X : Type*} [MetricSpace X]
    (pref : X → X → Prop)
    (indiff : X → X → Prop)
    (indiff_def : ∀ x y, indiff x y ↔ ¬ pref x y ∧ ¬ pref y x)
    (lns : ∀ x : X, ∀ ε > 0, ∃ y ∈ Metric.ball x ε, pref y x)
    (x : X) (ε : ℝ) (hε : ε > 0)
    (zone : ∀ y ∈ Metric.ball x ε, indiff y x) :
    False := by
  obtain ⟨y, hy_mem, hy_pref⟩ := lns x ε hε
  have h := zone y hy_mem
  rw [indiff_def] at h
  exact h.1 hy_pref