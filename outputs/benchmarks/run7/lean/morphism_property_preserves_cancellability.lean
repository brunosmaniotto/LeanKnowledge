import Mathlib

variable {S T : Type}

theorem left_cancellative_preserved (mul_S : S → S → S) (mul_T : T → T → T) (φ : S → T)
    (hφ : ∀ x y, φ (mul_S x y) = mul_T (φ x) (φ y)) (hinj : Function.Injective φ) (a : S)
    (ha : ∀ x y, mul_S x a = mul_S y a → x = y) : ∀ x y : S, mul_T (φ x) (φ a) = mul_T (φ y) (φ a) → φ x = φ y := by
  intro x y h
  have H : φ (mul_S x a) = φ (mul_S y a) := by rw [hφ, hφ, h]
  have H' : mul_S x a = mul_S y a := hinj H
  exact congrArg φ (ha x y H')