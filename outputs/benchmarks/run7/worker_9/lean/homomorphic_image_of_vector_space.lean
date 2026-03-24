import Mathlib

variable (K : Type _) [DivisionRing K] (V : Type _) [AddCommGroup V] [Module K V]
         (W : Type _) [AddCommGroup W] [Module K W] (φ : V →ₗ[K] W)

theorem homomorphic_image_is_vector_space (a b : K) (x y : φ.range) :
    a • (x + y) = a • x + a • y ∧
    (a + b) • x = a • x + b • x ∧
    (a * b) • x = a • (b • x) ∧
    (1 : K) • x = x := by
  have h1 : a • (x + y) = a • x + a • y := by
    ext
    simp [Submodule.coe_smul, Submodule.coe_add, smul_add]
  have h2 : (a + b) • x = a • x + b • x := by
    ext
    simp [Submodule.coe_smul, Submodule.coe_add, add_smul]
  have h3 : (a * b) • x = a • (b • x) := by
    ext
    simp [Submodule.coe_smul, mul_smul]
  have h4 : (1 : K) • x = x := by
    ext
    simp [Submodule.coe_smul, one_smul]
  exact ⟨h1, h2, h3, h4⟩