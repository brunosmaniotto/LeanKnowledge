import Mathlib

-- Revealed preference: x ≿* y iff ∃ B ∈ ℬ, x ∈ C(B) ∧ y ∈ B
-- For comparability, we need x,y to co-occur in some budget set where one is chosen.

-- We demonstrate non-completeness by constructing a choice structure on {0,1,2}
-- where alternatives 0 and 2 never appear together in any budget set.

inductive Alt3 : Type where
  | a | b | c
  deriving DecidableEq, Fintype

open Alt3

/-- A choice structure where budget sets are {a,b} and {b,c}.
    a and c never co-occur, so neither is revealed preferred to the other. -/
def budgets : Finset (Finset Alt3) :=
  {({a, b} : Finset Alt3), ({b, c} : Finset Alt3)}