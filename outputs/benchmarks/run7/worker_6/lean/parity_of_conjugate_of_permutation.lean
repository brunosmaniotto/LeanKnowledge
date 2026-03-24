import Mathlib

theorem ParityOfConjugateOfPermutation {n : ℕ} (π ρ : Equiv.Perm (Fin n)) :
    Equiv.Perm.sign (π * ρ * π⁻¹) = Equiv.Perm.sign ρ := by
  calc
    Equiv.Perm.sign (π * ρ * π⁻¹) = Equiv.Perm.sign (π * ρ) * Equiv.Perm.sign π⁻¹ := by rw [Equiv.Perm.sign_mul]
    _ = (Equiv.Perm.sign π * Equiv.Perm.sign ρ) * Equiv.Perm.sign π⁻¹ := by rw [Equiv.Perm.sign_mul]
    _ = (Equiv.Perm.sign π * Equiv.Perm.sign ρ) * Equiv.Perm.sign π := by rw [Equiv.Perm.sign_inv]
    _ = Equiv.Perm.sign π * Equiv.Perm.sign ρ * Equiv.Perm.sign π := by rw [mul_assoc]
    _ = Equiv.Perm.sign π * (Equiv.Perm.sign ρ * Equiv.Perm.sign π) := by rw [mul_assoc]
    _ = Equiv.Perm.sign π * (Equiv.Perm.sign π * Equiv.Perm.sign ρ) := by rw [mul_comm (Equiv.Perm.sign ρ) (Equiv.Perm.sign π)]
    _ = (Equiv.Perm.sign π * Equiv.Perm.sign π) * Equiv.Perm.sign ρ := by rw [mul_assoc]
    _ = Equiv.Perm.sign π * Equiv.Perm.sign π⁻¹ * Equiv.Perm.sign ρ := by rw [Equiv.Perm.sign_inv]
    _ = Equiv.Perm.sign (π * π⁻¹) * Equiv.Perm.sign ρ := by rw [← Equiv.Perm.sign_mul]
    _ = Equiv.Perm.sign (1 : Equiv.Perm (Fin n)) * Equiv.Perm.sign ρ := by simp
    _ = 1 * Equiv.Perm.sign ρ := by rw [Equiv.Perm.sign_one]
    _ = Equiv.Perm.sign ρ := by rw [one_mul]