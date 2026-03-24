import Mathlib

theorem double_negation (p : Prop) : ¬¬p → p :=
  Classical.by_contradiction