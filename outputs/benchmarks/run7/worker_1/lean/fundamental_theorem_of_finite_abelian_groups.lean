import Mathlib

open BigOperators

theorem fundamental_theorem_finite_abelian_groups (G : Type) [CommGroup G] [Fintype G] :
    ∃ (ι : Type) (hι : Fintype ι) (p : ι → ℕ) (e : ι → ℕ),
      (∀ i, Nat.Prime (p i)) ∧ Nonempty (G ≃* ((i : ι) → Multiplicative (ZMod (p i ^ e i)))) ∧
      ∀ (ι' : Type) (hι' : Fintype ι') (p' : ι' → ℕ) (e' : ι' → ℕ),
        (∀ i, Nat.Prime (p' i)) → Nonempty (G ≃* ((i : ι') → Multiplicative (ZMod (p' i ^ e' i)))) →
        ∃ (f : ι ≃ ι'), ∀ i, p i = p' (f i) ∧ e i = e' (f i) := by
  sorry