import Mathlib

theorem continuous_image_connected (T1 T2 : Type _) [TopologicalSpace T1] [TopologicalSpace T2]
    (S1 : Set T1) (hS1 : IsConnected S1) (f : T1 → T2) (hf : Continuous f) : IsConnected (f '' S1) :=
  hS1.image f (hf.continuousOn)