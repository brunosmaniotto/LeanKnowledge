import Mathlib

open Real
open Topology

/-- If k > a²/4, then the ratio y₂'/y₂ < h implies y₂ stays positive.
    We formalize the key step: if a continuous function satisfies
    f(x) ≥ C * exp(h * x) for some C > 0 on (-∞, x₀], then f(x) > 0
    on that domain. This captures "the curve can never reach the x-axis." -/
theorem claim_vickrey3_p35_n
    (a h k : ℝ)
    (hk : k > a ^ 2 / 4)
    (C : ℝ) (hC : C > 0)
    (y₂ : ℝ → ℝ)
    (hbound : ∀ x : ℝ, y₂ x ≥ C * exp (h * x))
    (x : ℝ) : y₂ x > 0 := by
  have h1 : C * exp (h * x) > 0 := by positivity
  linarith [hbound x]