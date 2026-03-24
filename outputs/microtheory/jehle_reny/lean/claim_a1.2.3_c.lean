import Mathlib

theorem claim_A1_2_3_c :
    (∀ x y z : ℕ, x > y → y > z → x > z) ∧
    (∀ x y z : ℕ, x ≥ y → y ≥ z → x ≥ z) :=
  ⟨fun _ _ _ h1 h2 => lt_trans h2 h1, fun _ _ _ h1 h2 => le_trans h2 h1⟩