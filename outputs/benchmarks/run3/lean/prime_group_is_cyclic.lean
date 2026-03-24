import Mathlib
open Fintype
open Topology

theorem prime_group_cyclic {p : ℕ} (hp : Nat.Prime p) (G : Type*) [Group G] [Fintype G]
    (h : card G = p) : IsCyclic G := by
  -- Create a Fact instance for the primality of p
  haveI : Fact (Nat.Prime p) := ⟨hp⟩
  -- Convert Fintype.card to Nat.card
  have h_card : Nat.card G = p := by
    rw [Nat.card_eq_fintype_card, h]
  -- Apply the Mathlib lemma
  exact isCyclic_of_prime_card h_card