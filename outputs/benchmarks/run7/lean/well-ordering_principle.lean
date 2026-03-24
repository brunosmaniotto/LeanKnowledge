import Mathlib

theorem well_ordering_principle_nat (S : Set ℕ) (hS : S.Nonempty) : ∃ m ∈ S, ∀ n ∈ S, m ≤ n := by
  have h_wf : WellFounded ((· < ·) : ℕ → ℕ → Prop) := Nat.lt_wfRel.wf
  obtain ⟨m, hm_in, hm_min⟩ := h_wf.has_min S hS
  exact ⟨m, hm_in, fun n hn => Nat.not_lt.mp (hm_min n hn)⟩