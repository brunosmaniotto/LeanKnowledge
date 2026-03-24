import Mathlib

open Filter
open Topology

/-- With dispersed preferences, at most one consumer has a nonconvexity at any price,
    so the fraction 1/n → 0 as population grows. -/
theorem claim_17I_f :
    Filter.Tendsto (fun n : ℕ => (1 : ℝ) / (↑n : ℝ)) Filter.atTop (nhds 0) := by
  have h : Filter.Tendsto (fun n : ℕ => (↑n : ℝ)⁻¹) Filter.atTop (nhds 0) := by
    exact tendsto_inv_atTop_zero.comp tendsto_natCast_atTop_atTop
  simp only [one_div] at *
  exact h