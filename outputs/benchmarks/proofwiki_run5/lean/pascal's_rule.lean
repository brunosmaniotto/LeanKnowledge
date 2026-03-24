import Mathlib

lemma succ_pred_eq_of_pos (k : ℕ) (hk : 0 < k) : (k - 1).succ = k := by
  exact Nat.succ_pred_eq_of_pos hk