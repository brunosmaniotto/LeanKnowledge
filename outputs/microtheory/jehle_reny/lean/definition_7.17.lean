import Mathlib
open Topology

-- Axiomatized framework for extensive form games
axiom ExtensiveFormGame : Type 1
axiom PureStrategy (Γ : ExtensiveFormGame) : Type
axiom Subgame (Γ : ExtensiveFormGame) : Type
axiom inducesNashEquilibrium (Γ : ExtensiveFormGame) : PureStrategy Γ → Subgame Γ → Prop

/-- Definition 7.17: A joint pure strategy s is a pure strategy subgame perfect
    equilibrium of the extensive form game Γ if s induces a Nash equilibrium
    in every subgame of Γ. -/
def IsSubgamePerfectEquilibrium (Γ : ExtensiveFormGame) (s : PureStrategy Γ) : Prop :=
  ∀ (S : Subgame Γ), inducesNashEquilibrium Γ s S