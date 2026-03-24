import Mathlib

instance direct_product_is_module (R : Type _) [Ring R] (n : ℕ) (G : Fin n → Type _)
    [∀ i, AddCommGroup (G i)] [∀ i, Module R (G i)] : Module R (∀ i : Fin n, G i) :=
  inferInstance