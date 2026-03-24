import Mathlib

theorem fifth_sylow_theorem (G : Type u) [Group G] [Fintype G] (p : ℕ) [Fact (Nat.Prime p)] (P : Sylow p G) :
    Fintype.card (Sylow p G) ∣ (P : Subgroup G).index := by
  have h := Sylow.card_dvd_index P
  rw [Nat.card_eq_fintype_card] at h
  exact h