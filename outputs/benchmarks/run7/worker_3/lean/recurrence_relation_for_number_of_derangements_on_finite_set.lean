import Mathlib

-- Proved sub-lemma 1
lemma n_eq_n_minus_one_plus_one (n : ℕ) (hn : 2 ≤ n) : n = n - 1 + 1 := by
  -- We can prove this by showing the equivalent statement `n - 1 + 1 = n`.
  symm
  -- This follows from `Nat.sub_add_cancel`, which states `k - m + m = k`
  -- given the hypothesis `m ≤ k`.
  -- In our case, `k` is `n` and `m` is `1`.
  apply Nat.sub_add_cancel
  -- The required hypothesis is `1 ≤ n`.
  -- This is provable from `hn : 2 ≤ n` because `1 ≤ 2`.
  linarith

-- Proved sub-lemma 2