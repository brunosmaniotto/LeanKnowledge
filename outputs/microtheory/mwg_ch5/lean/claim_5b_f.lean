import Mathlib

open Finset BigOperators

/-- If a production set has nonincreasing returns to scale (can scale down any feasible plan)
    and additivity (sum of feasible plans is feasible), then it is convex. -/
theorem Claim_5B_f {ι : Type*} (Y : Set (ι → ℝ))
    (nonincreasing_returns : ∀ y ∈ Y, ∀ α : ℝ, 0 ≤ α → α ≤ 1 → α • y ∈ Y)
    (additivity : ∀ y₁ ∈ Y, ∀ y₂ ∈ Y, y₁ + y₂ ∈ Y) :
    Convex ℝ Y := by
  intro y₁ hy₁ y₂ hy₂ α β hα hβ hαβ
  have h1 : α • y₁ ∈ Y := nonincreasing_returns y₁ hy₁ α hα (by linarith)
  have h2 : β • y₂ ∈ Y := nonincreasing_returns y₂ hy₂ β hβ (by linarith)
  have h3 : α • y₁ + β • y₂ ∈ Y := additivity _ h1 _ h2
  exact h3