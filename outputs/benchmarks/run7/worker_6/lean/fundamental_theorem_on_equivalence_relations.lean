import Mathlib.Data.Setoid.Partition

theorem fundamental_theorem_on_equivalence_relations (S : Type) (s : Setoid S) :
    Setoid.IsPartition (Setoid.classes s) :=
  Setoid.isPartition_classes s