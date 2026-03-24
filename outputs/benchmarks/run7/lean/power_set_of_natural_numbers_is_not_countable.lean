import Mathlib
open Cardinal

theorem not_countable_power_set_nat : ¬ Countable (Set ℕ) := by
  intro h
  have h_le : #(Set ℕ) ≤ #ℕ := by
    rw [Cardinal.mk_nat]
    exact Cardinal.mk_le_aleph0_iff.mpr h
  have h_lt : #ℕ < #(Set ℕ) := by
    rw [Cardinal.mk_set]
    exact Cardinal.cantor #ℕ
  exact lt_irrefl #ℕ (lt_of_lt_of_le h_lt h_le)