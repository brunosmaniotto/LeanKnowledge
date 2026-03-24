import Mathlib.GroupTheory.Perm.Sign

theorem sign_homomorphism (n : ℕ) (π ρ : Equiv.Perm (Fin n)) :
    Equiv.Perm.sign (π * ρ) = Equiv.Perm.sign π * Equiv.Perm.sign ρ :=
  Equiv.Perm.sign_mul π ρ