import Mathlib

theorem powerSet_is_sigma_algebra (S : Set α) :
    let 𝒜 : Set (Set S) := Set.univ
    (∅ ∈ 𝒜) ∧ (∀ A ∈ 𝒜, Aᶜ ∈ 𝒜) ∧ (∀ f : ℕ → Set S, (∀ i, f i ∈ 𝒜) → (⋃ i, f i) ∈ 𝒜) := by
  simp