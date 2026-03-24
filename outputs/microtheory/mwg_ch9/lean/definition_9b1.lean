import Mathlib
open Topology

/-- An extensive form game structure, parameterized by a type of nodes and a type of players. -/
structure ExtensiveFormGame (Node : Type*) (Player : Type*) where
  /-- The set of decision nodes (non-terminal). -/
  decisionNodes : Set Node
  /-- The successor relation: `succ x y` means `y` is an immediate successor of `x`. -/
  succ : Node → Node → Prop
  /-- The information set containing a given decision node. -/
  informationSet : Node → Set Node

/-- The reflexive-transitive closure of the successor relation:
    `x` is a weak successor of `y` if reachable via zero or more `succ` steps. -/
def ExtensiveFormGame.succStar {Node Player : Type*}
    (Γ : ExtensiveFormGame Node Player) : Node → Node → Prop :=
  Relation.ReflTransGen Γ.succ

/-- A subgame of an extensive form game Γ.

    A subgame is identified by a root node such that:
    (i)  The root's information set is a singleton {root}, and the subgame nodes
         are exactly the decision nodes reachable from root (inclusive).
    (ii) If any decision node x belongs to the subgame, then every node in x's
         information set also belongs to the subgame (no broken information sets). -/
structure Subgame {Node : Type*} {Player : Type*}
    (Γ : ExtensiveFormGame Node Player) where
  /-- The root decision node where the subgame begins. -/
  root : Node
  /-- The root is a decision node. -/
  root_decision : root ∈ Γ.decisionNodes
  /-- The root's information set is a singleton (condition (i), first part). -/
  root_singleton : Γ.informationSet root = {root}
  /-- The set of nodes in the subgame: all decision-node successors of root. -/
  nodes : Set Node := {x ∈ Γ.decisionNodes | Γ.succStar root x}
  /-- Information-set closure: if x is in the subgame, every node in H(x) is too
      (condition (ii), no broken information sets). -/
  info_set_closed : ∀ x ∈ nodes, ∀ x' ∈ Γ.informationSet x, x' ∈ nodes