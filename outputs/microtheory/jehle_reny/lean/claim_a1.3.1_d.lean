import Mathlib

theorem claim_A1_3_1_d {m : ℕ} (D : Set (EuclideanSpace ℝ (Fin m))) :
    IsOpen (Subtype.val ⁻¹' D : Set D) := by
  convert isOpen_univ
  ext ⟨x, hx⟩
  simp [hx]