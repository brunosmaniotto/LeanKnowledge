import Mathlib

-- We define a proposition that captures the axioms of a real inner product.
def IsRealInnerProduct {V : Type*} [AddCommGroup V] [Module ℝ V] (inner : V → V → ℝ) : Prop :=
  (∀ u v : V, inner u v = inner v u) ∧ -- Symmetry
  (∀ u v w : V, inner (u + v) w = inner u w + inner v w) ∧ -- Additivity in the first argument
  (∀ (c : ℝ) (u v : V), inner (c • u) v = c * inner u v) ∧ -- Homogeneity in the first argument
  (∀ u : V, 0 ≤ inner u u) ∧ -- Non-negativity
  (∀ u : V, inner u u = 0 ↔ u = 0) -- Positive definiteness

-- The theorem states that the dot product on `Fin n → ℝ` is a real inner product.