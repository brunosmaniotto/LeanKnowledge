import Mathlib

open MonoidHom

theorem rational_mul_group_is_normal_subgroup :
    (range (Units.map (algebraMap ℚ ℝ).toMonoidHom : ℚˣ →* ℝˣ)).Normal :=
  Subgroup.normal_of_comm _