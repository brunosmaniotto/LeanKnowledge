import Mathlib

variable {D : Type u} [CommRing D] [IsDomain D] [IsPrincipalIdealRing D]

theorem principal_ideal_of_irreducible_iff_maximal (p : D) (hp0 : p ≠ 0) :
    Irreducible p ↔ (Ideal.span {p} : Ideal D).IsMaximal := by
  constructor
  · intro hp
    exact PrincipalIdealRing.isMaximal_of_irreducible hp
  · intro hmax
    have hprime : (Ideal.span {p} : Ideal D).IsPrime :=
      Ideal.IsMaximal.isPrime hmax
    rw [Ideal.span_singleton_prime hp0] at hprime
    exact Prime.irreducible hprime