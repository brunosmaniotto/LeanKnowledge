import Mathlib

theorem mod_mul_closed (m : ℕ) (x y : ZMod m) : x * y ∈ (Set.univ : Set (ZMod m)) := by
  simp