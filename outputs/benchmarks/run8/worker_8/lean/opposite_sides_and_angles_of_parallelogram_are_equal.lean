import Mathlib

open scoped RealInnerProductSpace
open EuclideanGeometry

variable {V : Type _} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
variable {P : Type _} [MetricSpace P] [NormedAddTorsor V P]

def Parallelogram (A B C D : P) : Prop := (D -ᵥ A) = (C -ᵥ B)