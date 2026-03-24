import Mathlib

def restrict_bijection_to_complement {α β : Type*} (f : α ≃ β) (a : α) (b : β) (hf : f a = b) : 
  {x : α // x ≠ a} ≃ {y : β // y ≠ b} := by
  -- Define the forward function
  let g : {x : α // x ≠ a} → {y : β // y ≠ b} := fun ⟨x, hx⟩ => 
    ⟨f x, by 
      intro h
      have : x = a := f.injective (h.trans hf.symm)
      exact hx this⟩
  
  -- Define the backward function  
  let h : {y : β // y ≠ b} → {x : α // x ≠ a} := fun ⟨y, hy⟩ => 
    ⟨f.symm y, by 
      intro h
      have : y = b := by rw [← Equiv.apply_symm_apply f y, h, hf]
      exact hy this⟩
  
  -- Show they are inverses
  refine ⟨g, h, ?_, ?_⟩
  · intro ⟨x, hx⟩
    simp only [g, h]
    ext
    simp [Equiv.symm_apply_apply]
  · intro ⟨y, hy⟩  
    simp only [g, h]
    ext
    simp [Equiv.apply_symm_apply]