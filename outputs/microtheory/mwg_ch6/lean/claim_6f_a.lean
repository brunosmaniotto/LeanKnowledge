import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Given positive reals πₛ for s in a finite index set, we can normalize them
    so that the normalized values sum to 1. This is the key mathematical step
    in Claim 6F(a): the πₛ can be chosen to be subjective probabilities. -/
theorem subjective_probability_normalization
    {S : Type*} [Fintype S] [Nonempty S]
    (π : S → ℝ) (hπ : ∀ s, 0 < π s) :
    ∑ s : S, (π s / ∑ t : S, π t) = 1 := by
  have hsum_pos : 0 < ∑ t : S, π t := Finset.sum_pos (fun s _ => hπ s) univ_nonempty
  rw [← Finset.sum_div]
  exact div_self (ne_of_gt hsum_pos)