import Mathlib

open Classical in
open Topology
theorem Exercise_4_14_b
    (π : ℕ → ℝ)
    (hπ_mono : StrictAnti π)
    (h_pos : π 1 > 0)
    (h_neg : ∃ N : ℕ, π N < 0)
    : ∃ J_star : ℕ, J_star ≥ 1 ∧ π J_star ≥ 0 ∧ π (J_star + 1) < 0 := by
  obtain ⟨N, hN⟩ := h_neg
  have hN1 : 1 ≤ N := by
    by_contra h; push_neg at h
    have : N = 0 := by omega
    subst this
    linarith [hπ_mono (show (0 : ℕ) < 1 by omega)]
  have hP : ∃ n : ℕ, π (n + 1) < 0 :=
    ⟨N - 1, by rwa [Nat.sub_add_cancel hN1]⟩
  have hge1 : 1 ≤ Nat.find hP := by
    by_contra h; push_neg at h
    have h0 : Nat.find hP = 0 := by omega
    have := Nat.find_spec hP
    simp only [h0, zero_add] at this
    linarith
  refine ⟨Nat.find hP, hge1, ?_, Nat.find_spec hP⟩
  have h' := Nat.find_min hP (show Nat.find hP - 1 < Nat.find hP by omega)
  rw [Nat.sub_add_cancel hge1] at h'
  exact not_lt.mp h'