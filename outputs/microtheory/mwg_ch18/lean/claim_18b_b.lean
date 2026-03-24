import Mathlib

theorem Claim_18B_b
    (C : ℕ → Set α)
    (hC : Antitone C) :
    ∀ N, C (N + 1) ⊆ C N := by
  intro N
  exact hC (Nat.le_succ N)