import Mathlib

/-- The ring of polynomials over an integral domain is an integral domain. -/
theorem polynomial_ring_is_integral_domain (D : Type u) [CommRing D] [IsDomain D] : IsDomain (Polynomial D) :=
  inferInstance