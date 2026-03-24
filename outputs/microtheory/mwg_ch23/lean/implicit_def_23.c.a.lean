import Mathlib

def productExcept {I : ℕ} (Θ : Fin I → Type*) (i : Fin I) : Type _ :=
  (j : { k : Fin I // k ≠ i }) → Θ j.val