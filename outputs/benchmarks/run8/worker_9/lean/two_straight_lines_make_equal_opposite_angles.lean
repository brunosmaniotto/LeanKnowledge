import Mathlib

open EuclideanGeometry

variable {V : Type u} {P : Type v} [NormedAddCommGroup V] [InnerProductSpace ℝ V] [MetricSpace P] [NormedAddTorsor V P]

theorem vertical_angles (A B C D E : P) (h1 : ∠ A E B = Real.pi) (h2 : ∠ C E D = Real.pi) : ∠ A E C = ∠ B E D :=
  angle_eq_angle_of_angle_eq_pi_of_angle_eq_pi h1 h2