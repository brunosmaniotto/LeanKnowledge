import Mathlib
open Topology

structure ExtensiveFormGame (Node : Type*) (Player : Type*) where
  decisionNodes : Set Node
  succ : Node → Node → Prop
  informationSet : Node → Set Node

def ExtensiveFormGame.succStar {Node Player : Type*} (Γ : ExtensiveFormGame Node Player) : Node → Node → Prop :=
  Relation.ReflTransGen Γ.succ

structure Subgame {Node Player : Type*} (Γ : ExtensiveFormGame Node Player) where
  root : Node
  root_decision : root ∈ Γ.decisionNodes
  root_singleton : Γ.informationSet root = {root}
  nodes : Set Node := {x ∈ Γ.decisionNodes | Γ.succStar root x}
  info_set_closed : ∀ x ∈ nodes, ∀ x' ∈ Γ.informationSet x, x' ∈ nodes

variable {Node Player : Type*} (Γ : ExtensiveFormGame Node Player) (S : Subgame Γ)