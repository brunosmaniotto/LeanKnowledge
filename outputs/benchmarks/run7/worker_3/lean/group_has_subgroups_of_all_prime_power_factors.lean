import Mathlib.GroupTheory.Sylow

open Nat

theorem Group_has_Subgroups_of_All_Prime_Power_Factors
    (p k : ℕ) (G : Type*) [Group G] [Finite G]
    (hp : p.Prime) (h_dvd : p ^ k ∣ Nat.card G) :
    ∃ H : Subgroup G, Nat.card H = p ^ k := by
  haveI : Fact p.Prime := ⟨hp⟩
  exact Sylow.exists_subgroup_card_pow_prime p h_dvd