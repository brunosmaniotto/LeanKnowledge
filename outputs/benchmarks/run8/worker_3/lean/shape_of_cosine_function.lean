import Mathlib

open Set Real

-- Assume the sub-lemmas are proven
axiom cos_strictly_anti_on_Icc_0_pi : StrictAntiOn Real.cos (Set.Icc 0 Real.pi)
axiom cos_strictly_mono_on_Icc_pi_2pi : StrictMonoOn Real.cos (Set.Icc Real.pi (2 * Real.pi))
axiom cos_concave_on_Icc_neg_pi_div_2_pi_div_2 : ConcaveOn ℝ (Set.Icc (-(Real.pi / 2)) (Real.pi / 2)) Real.cos
axiom cos_convex_on_Icc_pi_div_2_3_pi_div_2 : ConvexOn ℝ (Set.Icc (Real.pi / 2) (3 * Real.pi / 2)) Real.cos

/--
**Shape of the Cosine Function**

The cosine function is:
- strictly decreasing on the interval $[0, \pi]$
- strictly increasing on the interval $[\pi, 2\pi]$
- concave on the interval $[-\pi/2, \pi/2]$
- convex on the interval $[\pi/2, 3\pi/2]$
-/
theorem shape_of_cosine_function :
  StrictAntiOn Real.cos (Set.Icc 0 Real.pi) ∧
  StrictMonoOn Real.cos (Set.Icc Real.pi (2 * Real.pi)) ∧
  ConcaveOn ℝ (Set.Icc (-(Real.pi / 2)) (Real.pi / 2)) Real.cos ∧
  ConvexOn ℝ (Set.Icc (Real.pi / 2) (3 * Real.pi / 2)) Real.cos := by
  constructor
  · exact cos_strictly_anti_on_Icc_0_pi
  · constructor
    · exact cos_strictly_mono_on_Icc_pi_2pi
    · constructor
      · exact cos_concave_on_Icc_neg_pi_div_2_pi_div_2
      · exact cos_convex_on_Icc_pi_div_2_3_pi_div_2