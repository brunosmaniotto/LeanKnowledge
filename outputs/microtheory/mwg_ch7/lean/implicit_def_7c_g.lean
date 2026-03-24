import Mathlib
open Topology

universe u v

/-- Common knowledge structure: formalizes the postulate that the game structure
    is common knowledge among all players. Given knowledge operators for each player,
    an event is common knowledge if every finite iteration of "everyone knows" holds. -/
structure CommonKnowledge (Ω : Type u) (I : Type v) where
  /-- Knowledge operator for each player -/
  K : I → Set Ω → Set Ω
  /-- Everyone-knows operator: intersection of all players' knowledge -/
  everyoneKnows (E : Set Ω) : Set Ω := ⋂ i, K i E
  /-- An event is common knowledge when it is known at all finite depths -/
  isCommonKnowledge (E : Set Ω) : Prop :=
    ∀ n : ℕ, ∀ ω ∈ E, ω ∈ Nat.iterate (fun S => ⋂ i, K i S) n E