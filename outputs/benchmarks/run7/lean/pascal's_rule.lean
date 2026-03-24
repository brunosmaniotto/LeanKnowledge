import Mathlib

lemma pascal_k_pred_succ (k : ℕ) (hk : 1 ≤ k) : k = (k - 1) + 1 := by
  exact (Nat.sub_add_cancel hk).symm