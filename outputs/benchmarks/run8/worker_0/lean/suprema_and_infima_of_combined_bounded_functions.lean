import Mathlib

open Set

variable {α : Type*}

theorem sup_add_const {f : α → ℝ} {S : Set α} (hS : S.Nonempty) (hf : BddAbove (f '' S)) (c : ℝ) :
    sSup ((fun x => f x + c) '' S) = sSup (f '' S) + c := by
  have h_image_nonempty : ((fun x => f x + c) '' S).Nonempty := hS.image (fun x => f x + c)
  have h_image_bdd : BddAbove ((fun x => f x + c) '' S) := by
    rcases hf with ⟨M, hM⟩
    use M + c
    rintro y ⟨x, hx, rfl⟩
    have hf_x : f x ≤ M := hM (mem_image_of_mem f hx)
    linarith
  apply le_antisymm
  · apply csSup_le h_image_nonempty
    rintro y ⟨x, hx, rfl⟩
    have hf_x : f x ≤ sSup (f '' S) := le_csSup hf (mem_image_of_mem f hx)
    linarith
  · have h : sSup (f '' S) ≤ sSup ((fun x => f x + c) '' S) - c := by
      apply csSup_le (hS.image f)
      rintro y ⟨x, hx, rfl⟩
      have hf_x : f x + c ≤ sSup ((fun x => f x + c) '' S) := le_csSup h_image_bdd (mem_image_of_mem (fun x => f x + c) hx)
      linarith
    linarith