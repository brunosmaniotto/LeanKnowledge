import Mathlib

open BigOperators Finset
open Topology

/-- Under Assumption 5.2, the income function m^i(p) = p · e^i + ∑_j θ^{ij} π^j(p)
    is continuous, since it is the sum of a continuous linear form (the dot product)
    and a finite linear combination of continuous profit functions. -/
theorem Claim_5_3_2_c
    {n J : ℕ}
    (e : Fin n → ℝ)
    (θ : Fin J → ℝ)
    (π : Fin J → (Fin n → ℝ) → ℝ)
    (hπ : ∀ j, Continuous (π j)) :
    Continuous (fun p : Fin n → ℝ => ∑ l, p l * e l + ∑ j, θ j * π j p) := by
  apply Continuous.add
  · exact continuous_finset_sum _ fun l _ => (continuous_apply l).mul continuous_const
  · exact continuous_finset_sum _ fun j _ => continuous_const.mul (hπ j)