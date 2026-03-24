import Mathlib
open Topology

theorem claim_2E_b {L : ℕ} (x : (Fin L → ℝ) → ℝ → ℝ)
    (hom : ∀ (p : Fin L → ℝ) (w : ℝ) (t : ℝ), t > 0 →
      x (t • p) (t * w) = x p w) :
    ∀ (p : Fin L → ℝ) (w : ℝ), w > 0 →
      x p w = x (w⁻¹ • p) 1 := by
  intro p w hw
  have h := hom p w w⁻¹ (inv_pos.mpr hw)
  simp [smul_smul, mul_comm w⁻¹ w, mul_inv_cancel₀ (ne_of_gt hw)] at h
  exact h.symm