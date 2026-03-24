import Mathlib

open Finset BigOperators Matrix
open Topology

/-- Claim 5.G(a): At fixed prices, higher profit expands every owner's budget set.
    If p · y' > p · y and θ_i ≥ 0, then any bundle affordable under y
    is also affordable under y'. -/
theorem claim_5G_a {n : ℕ} (p y y' : Fin n → ℝ) (w_i θ_i : ℝ)
    (hθ : θ_i ≥ 0)
    (hprofit : dotProduct p y' > dotProduct p y)
    (x : Fin n → ℝ)
    (hx : dotProduct p x ≤ w_i + θ_i * dotProduct p y) :
    dotProduct p x ≤ w_i + θ_i * dotProduct p y' := by
  have h : θ_i * dotProduct p y ≤ θ_i * dotProduct p y' := by
    apply mul_le_mul_of_nonneg_left (le_of_lt hprofit) hθ
  linarith