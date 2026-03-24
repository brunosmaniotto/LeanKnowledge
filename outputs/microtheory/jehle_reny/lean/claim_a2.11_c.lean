import Mathlib
open Topology

theorem Claim_A2_11_c
    {n : ℕ}
    (D : Fin n → ℝ)
    (h_alt : ∀ k : Fin n, (Odd (k.val + 1) → D k < 0) ∧ (Even (k.val + 1) → D k > 0)) :
    ∀ k : Fin n, (-1 : ℝ) ^ (k.val + 1) * D k > 0 := by
  intro k
  obtain ⟨hodd, heven⟩ := h_alt k
  rcases Nat.even_or_odd (k.val + 1) with ⟨m, hm⟩ | ⟨m, hm⟩
  · -- Even: k.val + 1 = m + m, so (-1)^(k.val+1) = 1
    have hDk := heven ⟨m, hm⟩
    have hpow : (-1 : ℝ) ^ (k.val + 1) = 1 := by
      rw [hm]; have : m + m = 2 * m := by omega
      rw [this, pow_mul]; simp
    rw [hpow, one_mul]; exact hDk
  · -- Odd: k.val + 1 = 2 * m + 1, so (-1)^(k.val+1) = -1
    have hDk := hodd ⟨m, hm⟩
    have hpow : (-1 : ℝ) ^ (k.val + 1) = -1 := by
      rw [hm, pow_add, pow_mul, pow_one]; simp
    rw [hpow]; linarith