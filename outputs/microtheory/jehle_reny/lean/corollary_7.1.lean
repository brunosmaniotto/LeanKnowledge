import Mathlib
open Topology

-- We formalize the statement by abstracting the core concepts of game theory using axioms.
-- This allows us to represent the logical structure of the argument without a concrete
-- implementation of extensive form games.

/-- A predicate asserting that a game `Γ` is a finite extensive form game. -/
axiom IsFiniteExtensiveFormGame (Γ : Type) : Prop

/-- A predicate asserting that a game `Γ` has perfect information. -/
axiom IsPerfectInformation (Γ : Type) : Prop

/-- The type of pure strategies for a given game `Γ`. -/
axiom PureStrategy (Γ : Type) : Type

/-- A predicate on a pure strategy `s` being a Nash Equilibrium for game `Γ`. -/
axiom IsNashEquilibrium {Γ : Type} (s : PureStrategy Γ) : Prop

/-- A predicate on a pure strategy `s` being a Subgame Perfect Nash Equilibrium for game `Γ`. -/
axiom IsSubgamePerfectEquilibrium {Γ : Type} (s : PureStrategy Γ) : Prop

/--
Axiom based on Proposition 9.B.2 (Zermelo's Theorem): Every finite extensive form game of perfect
information possesses at least one pure strategy subgame perfect equilibrium. This is the result
of applying the backward induction algorithm.
-/
axiom existence_of_spne (Γ : Type) (h_finite : IsFiniteExtensiveFormGame Γ) (h_pi : IsPerfectInformation Γ) :
  ∃ (s : PureStrategy Γ), IsSubgamePerfectEquilibrium s

/--
Axiom from the definition of SPNE: A strategy profile is a Subgame Perfect Nash Equilibrium if it
induces a Nash Equilibrium on every subgame. This implies it must also be a Nash Equilibrium
for the overall game.
-/
axiom spne_implies_ne {Γ : Type} {s : PureStrategy Γ} (h_spne : IsSubgamePerfectEquilibrium s) : IsNashEquilibrium s

/--
**Corollary 7.1**: Every finite extensive form game of perfect information possesses a pure
strategy Nash equilibrium.
-/
theorem Corollary_7_1 (Γ : Type)
    (h_finite : IsFiniteExtensiveFormGame Γ)
    (h_pi : IsPerfectInformation Γ) :
    ∃ (s : PureStrategy Γ), IsNashEquilibrium s := by
  -- By Zermelo's theorem, a pure strategy subgame perfect equilibrium exists.
  have ⟨s_spne, h_s_is_spne⟩ : ∃ s, IsSubgamePerfectEquilibrium s :=
    existence_of_spne Γ h_finite h_pi
  -- By definition, a subgame perfect equilibrium is also a Nash equilibrium.
  have h_s_is_ne : IsNashEquilibrium s_spne :=
    spne_implies_ne h_s_is_spne
  -- Therefore, a pure strategy Nash equilibrium exists.
  exact ⟨s_spne, h_s_is_ne⟩