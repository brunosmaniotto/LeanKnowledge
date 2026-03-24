import Mathlib

theorem external_direct_product_assoc (S T : Type) (op1 : S → S → S) (op2 : T → T → T)
  (h1 : ∀ a b c : S, op1 (op1 a b) c = op1 a (op1 b c))
  (h2 : ∀ a b c : T, op2 (op2 a b) c = op2 a (op2 b c)) :
  ∀ (x y z : S × T),
    (op1 (op1 x.1 y.1) z.1, op2 (op2 x.2 y.2) z.2) = (op1 x.1 (op1 y.1 z.1), op2 x.2 (op2 y.2 z.2)) := by
  intro x y z
  ext <;> simp [h1, h2]