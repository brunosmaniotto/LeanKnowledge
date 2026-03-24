import Mathlib

open Set
open Topology

theorem claim_A1_3_1_a :
    ∃ (f : ℝ → ℝ), Continuous f ∧
      ∃ (s : Set ℝ), IsOpen s ∧ ¬IsOpen (f '' s) := by
  refine ⟨fun _ => 0, continuous_const, Ioo 0 1, isOpen_Ioo, ?_⟩
  have hne : (Ioo (0 : ℝ) 1).Nonempty := ⟨1/2, by norm_num⟩
  have himg : (fun (_ : ℝ) => (0 : ℝ)) '' Ioo 0 1 = {0} := by
    ext x; simp [hne]
  rw [himg]
  exact not_isOpen_singleton (X := ℝ) (x := 0)