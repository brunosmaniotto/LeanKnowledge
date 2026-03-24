import Mathlib

variable {V : Type*} (G : SimpleGraph V)

theorem Graph_Connectedness_is_Equivalence_Relation : Equivalence G.Reachable :=
  SimpleGraph.reachable_is_equivalence G