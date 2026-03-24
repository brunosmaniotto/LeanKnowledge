import Mathlib

open Classical

noncomputable def χ (R : ℕ → ℕ → Prop) (x y : ℕ) : ℕ :=
  if R x y then 1 else 0

def sgn_bar (x : ℕ) : ℕ :=
  if x = 0 then 1 else 0