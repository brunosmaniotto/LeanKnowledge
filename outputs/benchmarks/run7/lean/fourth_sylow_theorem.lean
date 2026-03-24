import Mathlib

theorem Fourth_Sylow_Theorem (G : Type*) [Group G] [Fintype G] (p : ℕ) (hp : Nat.Prime p) :
    Fintype.card (Sylow p G) ≡ 1 [MOD p] := by
  classical
  haveI : Fact (Nat.Prime p) := ⟨hp⟩
  have h := card_sylow_modEq_one p G
  rw [Nat.card_eq_fintype_card] at h
  exact h