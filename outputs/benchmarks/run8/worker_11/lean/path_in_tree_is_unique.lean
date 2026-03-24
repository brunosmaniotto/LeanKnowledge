import Mathlib

variable {V : Type*} (T : SimpleGraph V)

theorem Path_in_Tree_is_Unique : T.IsTree ↔ Nonempty V ∧ ∀ u v : V, ∃! p : T.Walk u v, p.IsPath :=
  T.isTree_iff_existsUnique_path