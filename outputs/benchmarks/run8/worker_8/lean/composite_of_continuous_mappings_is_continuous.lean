import Mathlib

theorem Composite_of_Continuous_Mappings_is_Continuous {T1 T2 T3 : Type _} 
    [TopologicalSpace T1] [TopologicalSpace T2] [TopologicalSpace T3]
    (f : T1 → T2) (g : T2 → T3) (hf : Continuous f) (hg : Continuous g) : 
    Continuous (g ∘ f) :=
  hg.comp hf