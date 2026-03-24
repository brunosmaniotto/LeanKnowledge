import Mathlib

open Finset BigOperators
open BigOperators

/-- Definition 2.3: A utility function u: G → ℝ has the expected utility property
    if for every gamble g, u(g) = Σᵢ pᵢ · u(aᵢ), where (p₁,...,pₙ) is the
    simple lottery induced by g over the pure outcomes a₁,...,aₙ. -/
def HasExpectedUtilityProperty
    {N : ℕ} {G : Type*}
    (u : G → ℝ)
    (a : Fin N → G)
    (induced : G → Fin N → ℝ) : Prop :=
  ∀ g : G, u g = ∑ i : Fin N, induced g i * u (a i)