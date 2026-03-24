import Mathlib
open Topology

theorem Proposition_9B4
    (T : ℕ)
    (hT : T ≥ 1)
    (uniquely_determined : ℕ → Prop)
    (base : uniquely_determined 1)
    (ind_step : ∀ n : ℕ, n ≥ 2 →
      (∀ k : ℕ, 1 ≤ k → k ≤ n - 1 → uniquely_determined k) →
      uniquely_determined n)
    : uniquely_determined T := by
  suffices h : ∀ n : ℕ, ∀ k : ℕ, k ≤ n → k ≥ 1 → uniquely_determined k by
    exact h T T le_rfl hT
  intro n
  induction n with
  | zero => intro k hk hk1; omega
  | succ m ih =>
    intro k hk hk1
    by_cases h : k ≤ m
    · exact ih k h hk1
    · have hkm : k = m + 1 := by omega
      subst hkm
      by_cases h1 : m + 1 = 1
      · rw [h1]; exact base
      · apply ind_step (m + 1) (by omega)
        intro j hj1 hjn
        exact ih j (by omega) hj1