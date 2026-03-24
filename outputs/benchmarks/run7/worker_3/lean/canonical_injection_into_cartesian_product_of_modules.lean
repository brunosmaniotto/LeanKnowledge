import Mathlib

variable {R ι : Type*} [Semiring R] [DecidableEq ι] 
variable {M : ι → Type*} [∀ i, AddCommMonoid (M i)] [∀ i, Module R (M i)]

theorem canonical_injection_injective (j : ι) :
    Function.Injective (LinearMap.single R M j) :=
  Pi.single_injective j