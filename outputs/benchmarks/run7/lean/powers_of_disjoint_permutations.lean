import Mathlib

theorem powers_of_disjoint_permutations {α : Type _} [Fintype α] (σ ρ : Equiv.Perm α)
    (h_disjoint : Equiv.Perm.Disjoint σ ρ) (k : ℤ) : (σ * ρ) ^ k = σ ^ k * ρ ^ k := by
  have h_comm : Commute σ ρ := Equiv.Perm.Disjoint.commute h_disjoint
  exact h_comm.mul_zpow k