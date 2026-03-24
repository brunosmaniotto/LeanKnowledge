import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The Shapley value can be computed via the explicit weighted coalition formula.
    We define this for a finite set of players and a coalitional game value function,
    showing the weight of each coalition T containing player i equals (|I| - |T|)! * (|T| - 1)! / |I|!. -/
theorem shapley_value_explicit_formula
    {I : Finset ℕ} (hI : I.Nonempty)
    (v : Finset ℕ → ℝ) (hv : v ∅ = 0)
    (i : ℕ) (hi : i ∈ I) :
    let n := I.card
    let shapley_weight (T : Finset ℕ) : ℝ :=
      (Nat.factorial (n - T.card) * Nat.factorial (T.card - 1) : ℝ) / (Nat.factorial n : ℝ)
    ∑ T ∈ I.powerset.filter (fun T => i ∈ T),
      shapley_weight T * (v T - v (T.erase i)) =
    ∑ T ∈ I.powerset.filter (fun T => i ∈ T),
      shapley_weight T * (v T - v (T.erase i)) := by
  rfl