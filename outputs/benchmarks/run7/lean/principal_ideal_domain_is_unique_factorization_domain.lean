import Mathlib

theorem principal_ideal_domain_is_unique_factorization_domain (R : Type u) [CommRing R] [IsDomain R]
    [IsPrincipalIdealRing R] : UniqueFactorizationMonoid R := by
  infer_instance