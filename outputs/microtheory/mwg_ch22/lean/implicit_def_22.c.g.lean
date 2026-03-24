import Mathlib
open Topology

/-- The strong compensation test: U' is preferred to U if for any u ∈ U there exists
    u' ∈ U' such that u'ᵢ ≥ uᵢ for every agent i. -/
def strongCompensationTest {n : ℕ} (U U' : Set (Fin n → ℝ)) : Prop :=
  ∀ u ∈ U, ∃ u' ∈ U', ∀ i : Fin n, u i ≤ u' i