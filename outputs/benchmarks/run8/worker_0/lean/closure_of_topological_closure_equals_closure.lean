import Mathlib

variable {T : Type _} [TopologicalSpace T] (H : Set T)

theorem closure_closure_eq_closure : closure (closure H) = closure H :=
  closure_closure