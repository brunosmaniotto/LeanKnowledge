import Mathlib

theorem Z_module_associated_with_abelian_group_is_unitary (G : Type u) [AddCommGroup G] :
    (∀ (n : ℤ) (x y : G), n • (x + y) = n • x + n • y) ∧
    (∀ (n m : ℤ) (x : G), (n + m) • x = n • x + m • x) ∧
    (∀ (n m : ℤ) (x : G), (n * m) • x = n • (m • x)) ∧
    (∀ (x : G), (1 : ℤ) • x = x) := by
  simp [zsmul_add, add_zsmul, mul_zsmul, one_zsmul]