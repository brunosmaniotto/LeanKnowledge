import Mathlib

variable [TopologicalSpace T] (H : Set T) (x : T)

theorem condition_for_point_in_closure :
    x ∈ closure H ↔ ∀ (U : Set T), IsOpen U → x ∈ U → (U ∩ H).Nonempty :=
  mem_closure_iff