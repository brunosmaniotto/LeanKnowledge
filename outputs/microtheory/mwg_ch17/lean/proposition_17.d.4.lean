import Mathlib

open Matrix

theorem Proposition_17D4 {L : ℕ} (hL : 1 ≤ L) :
    ∀ (M : Matrix (Fin (L - 1)) (Fin L) ℝ),
      Function.Surjective (M.mulVecLin) →
      M.rank = L - 1 := by
  intro M hsurj
  have hsurj_lin := LinearMap.range_eq_top.mpr hsurj
  rw [Matrix.rank, hsurj_lin]
  simp [finrank_top, Module.finrank_fin_fun]