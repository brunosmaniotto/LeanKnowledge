import Mathlib

variable {S T : Type _} [CommSemigroup S] [CommMonoid T]

/-- An element `a` of a semigroup is cancellative if for all `b, c`, `a * b = a * c` implies `b = c`. -/
def IsCancellative [Mul α] (a : α) : Prop := ∀ (b c : α), a * b = a * c → b = c

variable (φ : MulHom S T) (C : Set S) (hC : C = {c | IsCancellative c})
variable (hinj : Function.Injective φ)
variable (hinv : ∀ c ∈ C, IsUnit (φ c))
variable (hsurj : ∀ t : T, ∃ (x : S) (y : C), t * φ y = φ x)