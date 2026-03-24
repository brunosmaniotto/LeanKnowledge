import Mathlib
open BigOperators
open Finset

/-- The second-best utility possibility set in Example 22.B.4 (few policy instruments).
With J consumers having quasilinear utility, no arbitrary transfers, and the surplus/deficit
absorbed by consumer 1, the set is parameterized by a single commodity tax p₂ on the second good. -/
noncomputable def secondBestUtilitySet
    (J : ℕ) (hJ : 1 ≤ J)
    (v : Fin J → ℝ → ℝ)
    (x : Fin J → ℝ → ℝ) :
    Set (Fin J → ℝ) :=
  {u | ∃ p₂ : ℝ, 0 < p₂ ∧
    (∀ j : Fin J, u j ≤
      if j = ⟨0, by omega⟩ then
        v ⟨0, by omega⟩ p₂ + (p₂ - 1) * ∑ i ∈ Finset.filter (· ≠ ⟨0, by omega⟩) Finset.univ, x i p₂
      else
        v j p₂)}