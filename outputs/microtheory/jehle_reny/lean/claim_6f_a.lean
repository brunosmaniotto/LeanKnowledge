import Mathlib
open Finset BigOperators
open Topology
open BigOperators

/-- Under Harsanyi's veil of ignorance with equal probability 1/N for each of N persons,
    the expected utility of social state x is Σᵢ (1/N) · uᵢ(x). -/
theorem harsanyi_veil_expected_utility
    (N : ℕ) (hN : 0 < N)
    (u : Fin N → ℝ) :
    ∑ i : Fin N, (1 / (N : ℝ)) * u i = (1 / (N : ℝ)) * ∑ i : Fin N, u i := by
  rw [Finset.mul_sum]