import Mathlib
open Topology

/-- A strategy profile assigns a strategy to each player.
    Given a finite set of players and a strategy set for each player,
    a strategy profile is a dependent function selecting one strategy per player. -/
abbrev StrategyProfile (I : Type*) (S : I → Type*) := (i : I) → S i

/-- Extract the strategy of player i from a profile. -/
abbrev StrategyProfile.ofPlayer {I : Type*} {S : I → Type*}
    (sp : StrategyProfile I S) (i : I) : S i :=
  sp i

/-- The strategies of all players other than i.
    Represents the s_{-i} notation from game theory. -/
abbrev StrategyProfile.others {I : Type*} [DecidableEq I] {S : I → Type*}
    (sp : StrategyProfile I S) (i : I) : (j : {j : I // j ≠ i}) → S j.val :=
  fun j => sp j.val

/-- Construct a strategy profile from player i's strategy and the others' strategies.
    This formalizes the (s_i, s_{-i}) decomposition. -/
noncomputable abbrev StrategyProfile.cons {I : Type*} [DecidableEq I] {S : I → Type*}
    (i : I) (si : S i) (s_neg_i : (j : {j : I // j ≠ i}) → S j.val) :
    StrategyProfile I S :=
  fun j => if h : j = i then h ▸ si else s_neg_i ⟨j, h⟩