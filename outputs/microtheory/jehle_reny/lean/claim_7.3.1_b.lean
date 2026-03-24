import Mathlib
open Topology

structure ExtensiveFormGame (Node : Type*) (Player : Type*) where
  infoSets : Set (Set Node)

def ExtensiveFormGame.isPerfectInformation {Node : Type*} {Player : Type*}
    (G : ExtensiveFormGame Node Player) : Prop :=
  ∀ S ∈ G.infoSets, ∃! n, n ∈ S