import Mathlib

theorem external_direct_product_hom {S1 S2 T1 T2 : Type*} [Mul S1] [Mul S2] [Mul T1] [Mul T2]
    (φ1 : S1 → T1) (h1 : ∀ x y : S1, φ1 (x * y) = φ1 x * φ1 y)
    (φ2 : S2 → T2) (h2 : ∀ x y : S2, φ2 (x * y) = φ2 x * φ2 y) :
    ∀ a b : S1 × S2, Prod.map φ1 φ2 (a * b) = Prod.map φ1 φ2 a * Prod.map φ1 φ2 b := by
  rintro ⟨a1, a2⟩ ⟨b1, b2⟩
  simp [Prod.map, h1, h2]