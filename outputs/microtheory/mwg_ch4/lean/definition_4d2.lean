import Mathlib
open Topology

/-- A Bergson-Samuelson social welfare function for `J` consumers.
    Maps utility profiles to social welfare, required to be increasing and concave. -/
structure SocialWelfareFunction (J : ℕ) where
  /-- The welfare function mapping utility profiles to social welfare. -/
  W : (Fin J → ℝ) → ℝ
  /-- W is increasing: if every consumer's utility weakly increases
      (with at least one strict increase), social welfare strictly increases. -/
  monotone : ∀ u v : Fin J → ℝ, (∀ j, u j ≤ v j) → (∃ j, u j < v j) → W u < W v
  /-- W is concave: W(t·u + (1-t)·v) ≥ t·W(u) + (1-t)·W(v) for t ∈ [0,1]. -/
  concave : ∀ u v : Fin J → ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
    W (fun j => t * u j + (1 - t) * v j) ≥ t * W u + (1 - t) * W v