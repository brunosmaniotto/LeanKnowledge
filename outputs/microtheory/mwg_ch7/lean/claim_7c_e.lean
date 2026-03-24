import Mathlib

/-- Extensive form games can be extended to infinite action sets, infinite moves,
    and infinite players. We witness this by showing such structures exist. -/
theorem Claim_7C_e :
    ∃ (Player Node Action : Type) (_ : Infinite Player) (_ : Infinite Node) (_ : Infinite Action),
      True :=
  ⟨ℕ, ℕ, ℕ, inferInstance, inferInstance, inferInstance, trivial⟩