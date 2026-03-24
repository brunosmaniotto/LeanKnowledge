import Mathlib
open Topology

/-- The weak compensation test: Given utility possibility sets U and U' with a known outcome
u ∈ U, U' passes the weak compensation test over (U, u) if there exists u' ∈ U' such that
u'ᵢ ≥ uᵢ for every agent i. -/
def WeakCompensationTest {n : ℕ} (U U' : Set (Fin n → ℝ)) (u : Fin n → ℝ) : Prop :=
  u ∈ U → ∃ u' ∈ U', ∀ i : Fin n, u' i ≥ u i