import Mathlib

structure OLGRealAsset where
  d1_z_a : ℝ → ℝ → ℝ
  d2_z_a : ℝ → ℝ → ℝ
  d1_z_b : ℝ → ℝ → ℝ
  p : ℝ
  hp_pos : 0 < p
  homogeneity_eq : d2_z_a (1 / p) 1 + d1_z_a 1 p = -d1_z_a 1 p + d1_z_b 1 p

def tatonnementStable (E : OLGRealAsset) : Prop :=
  E.d2_z_a (1 / E.p) 1 + E.d1_z_a 1 E.p < 0