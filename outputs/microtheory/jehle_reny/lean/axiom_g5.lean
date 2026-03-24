import Mathlib

open BigOperators Finset
open Topology

/-- **Axiom G5 (Substitution).** Given `N` outcomes, an indifference relation
    on simple lotteries `Fin N → ℝ` satisfies substitution when: for every
    number `K` of component lotteries, mixing weights `p`, and component
    lotteries `g` and `h`, if each `g i` is indifferent to `h i`, then
    the compound lottery mixing the `g i`'s is indifferent to the one
    mixing the `h i`'s (both reduced to simple lotteries via
    `fun n => ∑ i, p i * g i n`). -/
def SubstitutionAxiom {N : ℕ} (indiff : (Fin N → ℝ) → (Fin N → ℝ) → Prop) : Prop :=
  ∀ (K : ℕ) (p : Fin K → ℝ) (g h : Fin K → (Fin N → ℝ)),
    (∀ i, indiff (g i) (h i)) →
    indiff (fun n => ∑ i : Fin K, p i * g i n)
           (fun n => ∑ i : Fin K, p i * h i n)