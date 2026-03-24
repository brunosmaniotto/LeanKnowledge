import Mathlib

open Set

theorem set_diff_inter_eq (R S T : Set α) : (R \ S) ∩ T = (R ∩ T) \ S :=
  calc
    (R \ S) ∩ T = (R ∩ Sᶜ) ∩ T := by rw [diff_eq]
    _ = R ∩ (Sᶜ ∩ T) := by rw [inter_assoc]
    _ = R ∩ (T ∩ Sᶜ) := by rw [inter_comm Sᶜ T]
    _ = (R ∩ T) ∩ Sᶜ := by rw [← inter_assoc]
    _ = (R ∩ T) \ S := by rw [← diff_eq]