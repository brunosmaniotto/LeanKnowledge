import Mathlib

theorem exists_inverse_completion_nat : ∃ (G : Type) (_ : AddCommGroup G) (f : ℕ →+ G),
    Function.Injective f ∧ ∀ (g : G), ∃ (a b : ℕ), g = f a - f b := by
  refine ⟨ℤ, inferInstance, Nat.castAddMonoidHom ℤ, Int.ofNat_injective, ?_⟩
  intro g
  rcases g with (n | n)
  · exact ⟨n, 0, by simp⟩
  · exact ⟨0, n + 1, rfl⟩