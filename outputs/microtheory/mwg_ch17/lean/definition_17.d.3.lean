import Mathlib

/-- A system of M equations in N unknowns f : EuclideanSpace ℝ (Fin N) → EuclideanSpace ℝ (Fin M)
    is regular if the rank of its Jacobian Df(v) equals M whenever f(v) = 0.
    This is Definition 17.D.3 from MWG. -/
def IsRegularSystem {N M : ℕ} (f : EuclideanSpace ℝ (Fin N) → EuclideanSpace ℝ (Fin M)) : Prop :=
  ∀ v, f v = 0 →
    (fderiv ℝ f v).toLinearMap.range = ⊤ ∧ M ≤ N