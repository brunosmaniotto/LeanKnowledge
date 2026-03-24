import Mathlib

open Finset BigOperators

/--
With log social welfare W = Σ αᵢ ln(wᵢ), weights αᵢ > 0 summing to 1,
and budget constraint Σ wᵢ = w, the optimal distribution is wᵢ = αᵢ w.
We verify this for J = 2 consumers: the proposed allocation satisfies
the budget constraint and the first-order (equal marginal welfare) condition.
-/
theorem Example_4D1
    (α₁ α₂ : ℝ)
    (hα₁_pos : 0 < α₁)
    (hα₂_pos : 0 < α₂)
    (hα_sum : α₁ + α₂ = 1)
    (w : ℝ)
    (hw_pos : 0 < w) :
    -- (1) Budget feasibility: α₁ w + α₂ w = w
    α₁ * w + α₂ * w = w ∧
    -- (2) FOC: α₁/(α₁ w) = α₂/(α₂ w), i.e., equal marginal welfare per unit wealth
    α₁ / (α₁ * w) = α₂ / (α₂ * w) := by
  constructor
  · -- Budget: (α₁ + α₂) * w = 1 * w = w
    nlinarith
  · -- FOC: αᵢ/(αᵢ w) = 1/w for both i
    have h1 : α₁ * w ≠ 0 := by positivity
    have h2 : α₂ * w ≠ 0 := by positivity
    field_simp