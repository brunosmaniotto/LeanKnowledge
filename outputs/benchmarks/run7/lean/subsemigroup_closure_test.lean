import Mathlib

variable {S : Type _} [Semigroup S] (T : Set S)

/-- Given a subset `T` of a semigroup `S` that is closed under multiplication, we can construct a
subsemigroup with carrier `T`. -/
def subsemigroup_closure_test (h_mul : ∀ ⦃a b : S⦄, a ∈ T → b ∈ T → a * b ∈ T) : Subsemigroup S :=
  { carrier := T
    mul_mem' := @h_mul }