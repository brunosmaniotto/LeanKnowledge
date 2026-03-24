import Mathlib
open Topology

noncomputable section

variable {L : ℕ}

theorem Theorem_3_4_1a
    (c : (Fin L → ℝ) → ℝ → ℝ)
    (g_inv : ℝ → ℝ)
    (c_base : (Fin L → ℝ) → ℝ)
    (hg_inv_mono : StrictMono g_inv)
    (hg_inv_pos : 0 < g_inv 1)
    (hc : ∀ w y, c w y = g_inv y * c_base w) :
    ∃ h : ℝ → ℝ, StrictMono h ∧ ∀ w y, c w y = h y * c w 1 := by
  refine ⟨fun y => g_inv y / g_inv 1, ?_, ?_⟩
  · intro a b hab
    simp only [div_eq_mul_inv]
    exact mul_lt_mul_of_pos_right (hg_inv_mono hab) (inv_pos.mpr hg_inv_pos)
  · intro w y
    simp only [hc]
    have hne : g_inv 1 ≠ 0 := hg_inv_pos.ne'
    field_simp [hne]