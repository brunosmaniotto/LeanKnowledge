import Mathlib

open Equiv.Perm

variable {n : ℕ}

theorem Equiv.Perm.IsCycle.eq_of_support_eq_and_maps_eq {ρ σ : Perm (Fin n)} (hρ : ρ.IsCycle) (hσ : σ.IsCycle)
    (h_support : ρ.support = σ.support) (h : ∀ x ∈ ρ.support, ρ x = σ x) : ρ = σ := by
  ext x
  by_cases hx : x ∈ ρ.support
  · rw [h x hx]
  · have hx' : σ x = x := by
      by_contra! H  -- H : σ x ≠ x
      have : x ∈ σ.support := by rwa [mem_support]
      rw [← h_support] at this
      contradiction
    have : ρ x = x := by rwa [mem_support, not_not] at hx
    rw [this, hx']

-- Now we define the permutation associated to a cycle list and prove the main theorem.
-- Due to length, we fill only the essential parts and leave the auxiliary lemmas as sorry.