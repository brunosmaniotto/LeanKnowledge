import Mathlib

theorem prod_inv {M N : Type} [Monoid M] [Monoid N] (s : M) (t : N) (s_inv : M) (t_inv : N)
    (h1 : s * s_inv = 1 ∧ s_inv * s = 1) (h2 : t * t_inv = 1 ∧ t_inv * t = 1) :
    (s, t) * (s_inv, t_inv) = (1, 1) ∧ (s_inv, t_inv) * (s, t) = (1, 1) := by
  constructor
  · simp [h1.left, h2.left]
  · simp [h1.right, h2.right]