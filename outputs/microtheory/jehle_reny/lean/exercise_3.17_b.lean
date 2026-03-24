import Mathlib

open Finset BigOperators Filter Topology
open Filter
open Topology
open BigOperators

/-- CES production function: y = (Σᵢ αᵢ xᵢ^ρ)^{1/ρ} -/
noncomputable def cesProduction {n : ℕ} (α x : Fin n → ℝ) (ρ : ℝ) : ℝ :=
  (∑ i : Fin n, α i * (x i) ^ ρ) ^ (1 / ρ)

/-- As ρ → −∞, the CES production function converges to the Leontief (minimum) form:
    lim_{ρ→−∞} (Σᵢ αᵢ xᵢ^ρ)^{1/ρ} = min{x₁, …, xₙ}. -/
axiom exercise_3_17_b {n : ℕ} [NeZero n]
    (α x : Fin n → ℝ)
    (hα_pos : ∀ i, 0 < α i)
    (hα_sum : ∑ i : Fin n, α i = 1)
    (hx_pos : ∀ i, 0 < x i) :
    Tendsto (cesProduction α x) atBot
      (nhds (Finset.univ.inf' Finset.univ_nonempty x))