import Mathlib

theorem roys_identity
    {L : ℕ}
    (v : (Fin L → ℝ) → ℝ → ℝ)
    (x : (Fin L → ℝ) → ℝ → Fin L → ℝ)
    (dvdw : (Fin L → ℝ) → ℝ → ℝ)
    (dvdp : (Fin L → ℝ) → ℝ → Fin L → ℝ)
    (p : Fin L → ℝ) (w : ℝ)
    (lambda : ℝ)
    (hlam_ne : lambda ≠ 0)
    (hlam_w : dvdw p w = lambda)
    (hlam_p : ∀ ℓ : Fin L, dvdp p w ℓ = -lambda * x p w ℓ) :
    ∀ ℓ : Fin L, x p w ℓ = -(dvdp p w ℓ) / (dvdw p w) := by
  intro ℓ
  rw [hlam_w, hlam_p ℓ]
  field_simp