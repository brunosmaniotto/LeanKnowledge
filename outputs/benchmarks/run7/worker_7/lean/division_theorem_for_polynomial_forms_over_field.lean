import Mathlib
open Polynomial

theorem division_theorem (F : Type) [Field F] (f d : Polynomial F) (n : ℕ)
    (hdeg : d.natDegree = n) (hn : n ≥ 1) :
    ∃ q r, f = q * d + r ∧ (r = 0 ∨ (r ≠ 0 ∧ r.degree < (n : WithBot ℕ))) := by
  have hd : d ≠ 0 := by
    intro H
    rw [H, natDegree_zero] at hdeg
    linarith
  refine ⟨f / d, f % d, ?_, ?_⟩
  · rw [mul_comm, EuclideanDomain.div_add_mod f d]
  · have h_deg : degree (f % d) < (n : WithBot ℕ) := by
      rw [← hdeg, ← degree_eq_natDegree hd]
      exact EuclideanDomain.mod_lt f hd
    by_cases h : f % d = 0
    · left; exact h
    · right; exact ⟨h, h_deg⟩