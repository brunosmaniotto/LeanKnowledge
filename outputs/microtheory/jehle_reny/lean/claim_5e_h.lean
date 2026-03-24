import Mathlib

/-- In a two-type replica economy, if x̃ is in the core of E₁ but not a WEA,
    the coalition {1₁, 1₂, 2₁} blocks the twofold replication by giving
    each type-1 consumer the midpoint m = (e₁ + a₁)/2 and the type-2
    consumer a₂. Feasibility: m + m + a₂ = (e₁ + a₁) + a₂ = e₁ + (e₁ + e₂) = 2e₁ + e₂. -/
theorem Claim_5e_h
    {V : Type*} [AddCommGroup V]
    (e₁ e₂ : V)
    (a₁ a₂ : V)
    (m : V)
    (pref₁ : V → V → Prop) (weakPref₂ : V → V → Prop)
    -- Original allocation is feasible
    (h_feas : a₁ + a₂ = e₁ + e₂)
    -- m is the midpoint of e₁ and a₁
    (h_mid : m + m = e₁ + a₁)
    -- Strict convexity: a₁ ~₁ e₁ implies type 1 strictly prefers midpoint m
    (h_pref₁ : pref₁ m a₁)
    -- Reflexivity of weak preference for type 2
    (h_refl₂ : weakPref₂ a₂ a₂) :
    ∃ (y₁₁ y₁₂ y₂₁ : V),
      y₁₁ + y₁₂ + y₂₁ = e₁ + e₁ + e₂ ∧
      pref₁ y₁₁ a₁ ∧ pref₁ y₁₂ a₁ ∧
      weakPref₂ y₂₁ a₂ := by
  refine ⟨m, m, a₂, ?_, h_pref₁, h_pref₁, h_refl₂⟩
  calc m + m + a₂
      = (e₁ + a₁) + a₂ := by rw [h_mid]
    _ = e₁ + (a₁ + a₂) := add_assoc _ _ _
    _ = e₁ + (e₁ + e₂) := by rw [h_feas]
    _ = e₁ + e₁ + e₂ := (add_assoc _ _ _).symm