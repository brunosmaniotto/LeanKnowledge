import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- In the VCG mechanism, truthful reporting is a weakly dominant strategy.

Agent i's utility when reporting rᵢ (with others reporting t₋ᵢ) equals:
  uᵢ = Σⱼ vⱼ(x̂(rᵢ, t₋ᵢ), tⱼ) − Σ_{j≠i} vⱼ(x̃ᵢ(t₋ᵢ), tⱼ)

Since x̂(tᵢ, t₋ᵢ) maximizes Σⱼ vⱼ(·, tⱼ) over all outcomes and the second
term is independent of i's report, truthful reporting maximizes utility. -/
theorem vcg_truthful_dominance
    {N : ℕ} {X : Type*}
    (v : Fin N → X → ℝ)
    (i : Fin N)
    (x_truth x_deviate x_without_i : X)
    -- Key VCG property: x_truth = x̂(tᵢ, t₋ᵢ) maximizes total welfare
    (h_welfare_max : ∀ x : X, ∑ j : Fin N, v j x ≤ ∑ j : Fin N, v j x_truth) :
    -- Utility under truthful report ≥ utility under any deviation
    (∑ j : Fin N, v j x_truth) - (∑ j ∈ univ.filter (· ≠ i), v j x_without_i) ≥
    (∑ j : Fin N, v j x_deviate) - (∑ j ∈ univ.filter (· ≠ i), v j x_without_i) := by
  linarith [h_welfare_max x_deviate]