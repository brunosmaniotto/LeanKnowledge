import Mathlib

-- We introduce `Firm` and `Market` as types to allow for a general definition
variable {Firm : Type}
variable {Market : Type}

/-- A situation of oligopoly is one in which more than one, but still not many, firms compete in a market. -/
def IsOligopolySituation (firms : Finset Firm) (market : Market) : Prop :=
  firms.card > 1