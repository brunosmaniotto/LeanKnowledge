import Mathlib

instance group_acts_on_itself (G : Type*) [Group G] : MulAction G G where
  smul := (· * ·)
  one_smul := one_mul
  mul_smul := mul_assoc