import Mathlib

theorem Finite_Intersection_of_Open_Sets_of_Metric_Space_is_Open
    {A : Type*} [MetricSpace A] {I : Type*} [Fintype I] {U : I → Set A}
    (h : ∀ i : I, IsOpen (U i)) : IsOpen (⋂ i : I, U i) :=
  isOpen_iInter_of_finite h