import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Claim 1.4.2(c): The Hicksian demand xʰ(p,ū) solves the expenditure
    minimisation problem, and the expenditure p·xʰ equals the minimum
    expenditure e(p,ū). -/
theorem Claim_1_4_2_c
    {n : ℕ}
    (p xh : Fin n → ℝ)
    (ū e_val : ℝ)
    (u : (Fin n → ℝ) → ℝ)
    -- xh is feasible: u(xh) ≥ ū
    (h_feasible : u xh ≥ ū)
    -- xh minimises expenditure among feasible bundles
    (h_min : ∀ x : Fin n → ℝ, u x ≥ ū → ∑ i, p i * xh i ≤ ∑ i, p i * x i)
    -- e_val is a lower bound on expenditure over feasible bundles
    (h_lb : ∀ x : Fin n → ℝ, u x ≥ ū → e_val ≤ ∑ i, p i * x i)
    -- e_val is the greatest such lower bound
    (h_glb : ∀ b : ℝ, (∀ x : Fin n → ℝ, u x ≥ ū → b ≤ ∑ i, p i * x i) → b ≤ e_val) :
    ∑ i, p i * xh i = e_val := by
  apply le_antisymm
  · -- p·xh is a lower bound (by h_min), so ≤ the greatest lower bound e_val
    exact h_glb _ h_min
  · -- e_val is a lower bound, xh is feasible, so e_val ≤ p·xh
    exact h_lb xh h_feasible