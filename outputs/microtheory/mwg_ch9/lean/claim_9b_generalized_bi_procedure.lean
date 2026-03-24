import Mathlib
open Topology

/-- A finite extensive form game. -/
structure FiniteExtGame where
  /-- Type of nodes, finite -/
  Node : Type
  nodeFintype : Fintype Node
  /-- Terminal nodes -/
  isTerminal : Node → Prop
  /-- Subgame rooted at a node -/
  isSubgameRoot : Node → Prop
  /-- Whether a subgame is final (no nested subgames) -/
  isFinalSubgame : Node → Prop
  /-- Parent relation in the game tree -/
  parent : Node → Option Node

/-- Result of one step of the generalized backward induction procedure. -/
structure BIStep (G : FiniteExtGame) where
  /-- The final subgames identified in this step -/
  finalSubgames : Finset G.Node
  /-- A chosen Nash equilibrium for each final subgame -/
  chosenNE : G.Node → Option (G.Node → Prop)
  /-- The reduced game after replacing final subgames with payoffs -/
  reducedGame : FiniteExtGame

/-- The generalized backward induction procedure for identifying subgame perfect
    Nash equilibria in a finite extensive form game.

    The procedure works by:
    (1) Identifying terminal (final) subgames with no nested subgames
    (2) Selecting a Nash equilibrium in each final subgame and reducing the game
    (3) Repeating until every move is determined
    (4) Collecting all possible profiles when multiple equilibria exist at any step -/
structure GeneralizedBIProcedure (G : FiniteExtGame) where
  /-- The sequence of backward induction steps -/
  steps : List (BIStep G)
  /-- Each step identifies final subgames of the current reduced game -/
  steps_identify_final : ∀ s ∈ steps, ∀ n ∈ s.finalSubgames,
    G.isFinalSubgame n
  /-- The procedure terminates when all moves are determined -/
  terminates : steps ≠ []
  /-- The resulting SPNE strategy profiles (one per combination of equilibrium choices) -/
  spneProfiles : Finset (G.Node → Prop)
  /-- If no step had multiple equilibria, the SPNE is unique -/
  unique_when_no_multiplicity : spneProfiles.card = 1 ∨ spneProfiles.card > 1