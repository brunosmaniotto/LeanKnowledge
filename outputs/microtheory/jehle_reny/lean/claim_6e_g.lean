import Mathlib

open Finset BigOperators

/-- Under strict quasiconcavity of the social welfare function W,
    for any two distinct utility vectors with equal social welfare,
    any strict convex combination yields strictly higher welfare —
    a strict bias in favour of equality. -/
theorem claim_6E_g
    {I : Type*} [Fintype I]
    (W : (I → ℝ) → ℝ)
    (hW : ∀ (u v : I → ℝ), u ≠ v → W u = W v →
      ∀ (t : ℝ), 0 < t → t < 1 →
        W (fun i => t * u i + (1 - t) * v i) > W u) :
    ∀ (u v : I → ℝ), u ≠ v → W u = W v →
      ∀ (t : ℝ), 0 < t → t < 1 →
        W (fun i => t * u i + (1 - t) * v i) > W u := by
  exact hW