import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A Walrasian demand correspondence maps a strictly positive price vector
    and positive wealth to a set of consumption bundles. -/
def WalrasLaw (n : ℕ) (x : (Fin n → ℝ) → ℝ → Set (Fin n → ℝ)) : Prop :=
  ∀ p : Fin n → ℝ, ∀ w : ℝ,
    (∀ i, p i > 0) →
    w > 0 →
    ∀ bundle ∈ x p w, ∑ i : Fin n, p i * bundle i = w