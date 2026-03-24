import Mathlib

/-- An equilibrium wage in an asymmetric information market is a fixed point
    of the conditional expectation. We model this as w*(w-1)=0, which has
    multiple solutions, demonstrating non-uniqueness. -/
def IsEquilibriumWage (w : ℝ) : Prop := w * (w - 1) = 0