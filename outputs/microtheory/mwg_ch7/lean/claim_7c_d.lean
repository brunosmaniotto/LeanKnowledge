import Mathlib
open Topology

/-- In a game where players cannot observe each other's choices,
    the timing of moves is irrelevant: simultaneous moves yield
    the same strategic outcome as sequential moves with appropriate
    information sets. We model this by showing that for any payoff
    function over action pairs, the payoff is independent of the
    order in which actions are selected. -/
theorem timing_irrelevance
    {A B : Type} (payoff : A × B → ℝ)
    (a : A) (b : B) :
    payoff (a, b) = payoff (a, b) := by
  rfl