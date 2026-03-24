import Mathlib

universe u v

def epimorphism_preserves_ring {R1 : Type u} {R2 : Type v} [Ring R1] [Add R2] [Mul R2] [Zero R2] [One R2] [Neg R2] [Sub R2]
    [SMul ℕ R2] [SMul ℤ R2] [Pow R2 ℕ] [NatCast R2] [IntCast R2] (φ : R1 → R2) (hφ : Function.Surjective φ)
    (hzero : φ 0 = 0) (hone : φ 1 = 1) (hadd : ∀ x y, φ (x + y) = φ x + φ y) (hmul : ∀ x y, φ (x * y) = φ x * φ y)
    (hneg : ∀ x, φ (-x) = -φ x) (hsub : ∀ x y, φ (x - y) = φ x - φ y)
    (hnsmul : ∀ (n : ℕ) (x : R1), φ (n • x) = n • φ x) (hzsmul : ∀ (n : ℤ) (x : R1), φ (n • x) = n • φ x)
    (hnpow : ∀ (x : R1) (n : ℕ), φ (x ^ n) = φ x ^ n) (hnat_cast : ∀ n : ℕ, φ n = n) (hint_cast : ∀ n : ℤ, φ n = n) :
    Ring R2 :=
  Function.Surjective.ring φ hφ hzero hone hadd hmul hneg hsub hnsmul hzsmul hnpow hnat_cast hint_cast