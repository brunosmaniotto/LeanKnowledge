import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Theorem_A2_16
    {n m : ℕ}
    (grad_f : Fin n → ℝ)
    (grad_g : Fin m → Fin n → ℝ)
    (h_licq : LinearIndependent ℝ grad_g)
    (h_in_span : ∃ c : Fin m → ℝ, grad_f = ∑ j : Fin m, c j • grad_g j) :
    ∃! mu : Fin m → ℝ, ∀ i : Fin n,
      grad_f i - ∑ j : Fin m, mu j * grad_g j i = 0 := by
  obtain ⟨lam, hlam⟩ := h_in_span
  refine ⟨lam, ?_, ?_⟩
  · intro i
    have := congr_fun hlam i
    simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul] at this
    linarith
  · intro mu hmu
    have hmu_vec : grad_f = ∑ j : Fin m, mu j • grad_g j := by
      ext i; simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul]; linarith [hmu i]
    rw [Fintype.linearIndependent_iff] at h_licq
    have h_zero : ∑ j : Fin m, (mu j - lam j) • grad_g j = 0 := by
      simp_rw [sub_smul]
      rw [Finset.sum_sub_distrib, ← hmu_vec, ← hlam, sub_self]
    exact funext fun j => sub_eq_zero.mp (h_licq _ h_zero j)