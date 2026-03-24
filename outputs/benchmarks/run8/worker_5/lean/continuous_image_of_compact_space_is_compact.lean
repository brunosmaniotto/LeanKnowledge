import Mathlib

open Set

theorem Continuous_Image_of_Compact_Space_is_Compact (T1 T2 : Type _) [TopologicalSpace T1] [TopologicalSpace T2]
    (f : T1 → T2) (hf : Continuous f) [CompactSpace T1] : IsCompact (range f) :=
  isCompact_range hf