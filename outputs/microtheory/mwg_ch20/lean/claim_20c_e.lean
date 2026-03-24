import Mathlib

structure EfficientPath where
  T : ℕ
  q_b : Fin (T + 1) → ℝ
  q_a : Fin (T + 1) → ℝ
  q_b_pos : ∀ t, q_b t > 0

theorem malinvaud_prices_exist (path : EfficientPath)
    (h_prop : ∀ t : Fin path.T,
      ∃ β > 0, path.q_a ⟨t.val, Nat.lt_succ_of_lt t.isLt⟩ =
        β * path.q_b ⟨t.val + 1, Nat.succ_lt_succ t.isLt⟩) :
    ∀ t : Fin path.T,
      ∃ β > 0, path.q_a ⟨t.val, Nat.lt_succ_of_lt t.isLt⟩ =
        β * path.q_b ⟨t.val + 1, Nat.succ_lt_succ t.isLt⟩ := by
  exact h_prop