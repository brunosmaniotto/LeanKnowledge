import Mathlib

theorem URM_computable_comp {f g : ℕ → ℕ} (hf : Computable f) (hg : Computable g) :
    Computable (f ∘ g) :=
  hf.comp hg