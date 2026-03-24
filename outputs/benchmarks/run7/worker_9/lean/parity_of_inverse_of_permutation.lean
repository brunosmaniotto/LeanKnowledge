import Mathlib

theorem sign_eq_sign_inv (n : ℕ) (π : Equiv.Perm (Fin n)) : Equiv.Perm.sign π = Equiv.Perm.sign π⁻¹ :=
  (Equiv.Perm.sign_inv π).symm