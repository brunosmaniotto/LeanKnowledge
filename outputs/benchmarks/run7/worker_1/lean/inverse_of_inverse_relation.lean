import Mathlib

theorem inverse_of_inverse_eq_self (r : Set (α × β)) : Prod.swap ⁻¹' (Prod.swap ⁻¹' r) = r := by
  ext ⟨a, b⟩
  constructor
  · intro h
    simp_rw [Set.mem_preimage, Prod.swap_prod_mk] at h
    exact h
  · intro h
    simp_rw [Set.mem_preimage, Prod.swap_prod_mk]
    exact h