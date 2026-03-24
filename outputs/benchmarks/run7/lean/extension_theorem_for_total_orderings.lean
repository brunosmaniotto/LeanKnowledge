import Mathlib

-- Sub-lemma 1: Extended order is total
lemma extended_order_total {S : Type*} [CommMonoid S] [LinearOrder S] (T : Type*) [CommGroup T] 
    (ι : S →* T) (hsurj : ∀ t : T, ∃ s₁ s₂ : S, t = ι s₁ * (ι s₂)⁻¹) : 
    ∀ t₁ t₂ : T, (∃ x₁ y₁ x₂ y₂ : S, t₁ = ι x₁ * (ι y₁)⁻¹ ∧ t₂ = ι x₂ * (ι y₂)⁻¹ ∧ x₁ * y₂ ≤ x₂ * y₁) ∨ 
                 (∃ x₁ y₁ x₂ y₂ : S, t₁ = ι x₁ * (ι y₁)⁻¹ ∧ t₂ = ι x₂ * (ι y₂)⁻¹ ∧ x₂ * y₁ ≤ x₁ * y₂) := by
  intro t₁ t₂
  -- Use surjectivity to express t₁ and t₂ as fractions
  obtain ⟨x₁, y₁, h₁⟩ := hsurj t₁
  obtain ⟨x₂, y₂, h₂⟩ := hsurj t₂
  -- Use totality of the linear order on S
  cases' le_total (x₁ * y₂) (x₂ * y₁) with h h
  · -- Case: x₁ * y₂ ≤ x₂ * y₁
    left
    exact ⟨x₁, y₁, x₂, y₂, h₁, h₂, h⟩
  · -- Case: x₂ * y₁ ≤ x₁ * y₂
    right
    exact ⟨x₁, y₁, x₂, y₂, h₁, h₂, h⟩

-- Sub-lemma 2: Extended order restricts correctly to S