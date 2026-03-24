import Mathlib

/-- A subring of an integral domain is an integral domain. -/
theorem subdomain_test (R : Type*) [CommRing R] [IsDomain R] (S : Subring R) : IsDomain S :=
  inferInstance