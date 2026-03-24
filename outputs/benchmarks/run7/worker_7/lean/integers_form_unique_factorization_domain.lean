import Mathlib

theorem integers_form_unique_factorization_domain : IsDomain ℤ ∧ UniqueFactorizationMonoid ℤ :=
  ⟨inferInstance, inferInstance⟩