import Mathlib

theorem mappings_between_residue_classes (m n : ℕ) :
    (∀ (x y : ℤ), (m : ℤ) ∣ x - y → (n : ℤ) ∣ x - y) ↔ n ∣ m := by
  constructor
  · intro h
    have := h (m : ℤ) 0 (by simp)
    simp at this
    exact_mod_cast this
  · intro h x y hdvd
    have : (n : ℤ) ∣ (m : ℤ) := by exact_mod_cast h
    exact dvd_trans this hdvd