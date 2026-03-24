import Mathlib

/-- Sen (1970a) defines a social choice function f to satisfy welfarism if f satisfies
    Unrestricted domain (U), Independence of Irrelevant Alternatives (IIA),
    and Pareto Indifference (PI) — without requiring the Weak Pareto principle (WP). -/
def SatisfiesWelfarism (satisfiesU : Prop) (satisfiesIIA : Prop) (satisfiesPI : Prop) : Prop :=
  satisfiesU ∧ satisfiesIIA ∧ satisfiesPI