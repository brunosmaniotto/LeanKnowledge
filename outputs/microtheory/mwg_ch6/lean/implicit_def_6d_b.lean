import Mathlib

open MeasureTheory Set

/-- G(·) is an elementary increase in risk from F(·) if G is obtained by taking all
    mass F assigns to some interval [a, b] and redistributing it to the endpoints
    a and b while preserving the mean over that interval. -/
def ElementaryIncreaseInRisk (F G : Measure ℝ) : Prop :=
  ∃ (a b : ℝ), a < b ∧
    -- G agrees with F outside [a, b]
    (∀ S : Set ℝ, MeasurableSet S → Disjoint S (Icc a b) → G S = F S) ∧
    -- G places no mass in the open interior (a, b)
    G (Ioo a b) = 0 ∧
    -- Total mass on [a, b] is conserved
    G (Icc a b) = F (Icc a b) ∧
    -- Mean over [a, b] is preserved (making it a mean-preserving spread)
    ∫ x in Icc a b, x ∂G = ∫ x in Icc a b, x ∂F