import Mathlib
open Finset

noncomputable def aggregateSupply (J : ℕ)
    (q_individual : Fin J → (ℝ → ℝ))
    (p_min_threshold : ℝ) : ℝ → ℝ :=
  fun (p : ℝ) =>
    if p ≤ p_min_threshold then
      0
    else
      Finset.sum (Finset.univ : Finset (Fin J)) (fun j => q_individual j p)