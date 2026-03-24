import Mathlib
open Topology

/-- Meeting in New York (Example 7B3).
    A two-player pure coordination game. Mr. Thomas and Mr. Schelling
    independently choose a location in New York City.
    Returns the payoff pair (Thomas's payoff, Schelling's payoff):
    (100, 100) if they choose the same location, (0, 0) otherwise. -/
def meetingInNewYork {Location : Type*} [DecidableEq Location]
    (thomas schelling : Location) : ℕ × ℕ :=
  if thomas = schelling then (100, 100) else (0, 0)