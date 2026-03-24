import Mathlib

theorem First_Sylow_Theorem (G : Type u) [Group G] [Fintype G] (p : ℕ) [Fact (Nat.Prime p)]
    (k n : ℕ) (h : Fintype.card G = k * p ^ n) (hp : ¬ p ∣ k) : Nonempty (Sylow p G) :=
  Sylow.nonempty