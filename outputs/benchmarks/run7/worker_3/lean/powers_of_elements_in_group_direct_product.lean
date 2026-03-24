import Mathlib

variable {G H : Type} [Group G] [Group H]

theorem prod_pow_eq (n : ℤ) (g : G) (h : H) : (g, h) ^ n = (g ^ n, h ^ n) := rfl