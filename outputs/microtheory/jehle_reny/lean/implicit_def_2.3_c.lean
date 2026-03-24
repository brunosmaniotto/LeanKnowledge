import Mathlib

open BigOperators Finset
open Topology

/-- Slutsky compensated demand: given a demand function `x` and a reference bundle `x₀`,
    at prices `p` the consumer's wealth is set to `p · x₀` so that `x₀` remains just affordable,
    and the choice is `x(p, p · x₀)`. -/
noncomputable def slutskyCompensatedDemand {L : ℕ}
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (x₀ : Fin L → ℝ)
    (p : Fin L → ℝ) : Fin L → ℝ :=
  x p (∑ i : Fin L, p i * x₀ i)