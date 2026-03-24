import Mathlib

variable {T : Type} [TopologicalSpace T] (H : Set T)

theorem closure_isClosed : IsClosed (closure H) :=
  isClosed_closure