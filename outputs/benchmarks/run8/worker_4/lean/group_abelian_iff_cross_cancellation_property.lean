import Mathlib

variable (G : Type) [Group G]

/-- The cross cancellation property: for all a, b, c, if a * b = c * a then b = c. -/
def crossCancellation : Prop := ∀ a b c : G, a * b = c * a → b = c