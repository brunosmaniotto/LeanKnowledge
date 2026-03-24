import Mathlib
open Topology

universe u

/-- An abstract structure for an extensive form game `Γ`, defining its information sets
and the actions available at each. -/
class ExtensiveFormGame (Γ : Type u) where
  InfoSet : Type u
  Action (I : InfoSet) : Type u

/-- A joint pure strategy for a game `Γ` specifies an action for every information set. -/
abbrev JointPureStrategy (Γ : Type u) [ExtensiveFormGame Γ] :=
  (I : ExtensiveFormGame.InfoSet Γ) → ExtensiveFormGame.Action I

/-- A subgame `Γ_x` of a game `Γ` is characterized by a subset of `Γ`'s information sets. -/
structure Subgame (Γ : Type u) [ExtensiveFormGame Γ] where
  infoSets : Set (ExtensiveFormGame.InfoSet Γ)

/-- Given a joint pure strategy `s` for `Γ` and a subgame `Γ_x`, the induced
strategy for the subgame is the restriction of `s` to the subgame's information sets. -/
def induced_strategy {Γ : Type u} [ExtensiveFormGame Γ]
  (s : JointPureStrategy Γ) (Γ_x : Subgame Γ) :
  (I : {i // i ∈ Γ_x.infoSets}) → ExtensiveFormGame.Action I.val :=
  fun I ↦ s I.val