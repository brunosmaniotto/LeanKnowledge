import Mathlib

-- This file proves the existence and uniqueness of the smallest normal subgroup
-- of a group G containing a given set S. This subgroup is known as the
-- normal closure of S in G.

-- The proof is structured by first proving two key sub-lemmas and then
-- assembling them to prove the main theorem.

-- Sub-lemma 1: Uniqueness.
-- This lemma establishes that if two subgroups N₁ and N₂ both satisfy the
-- condition of being a "smallest normal subgroup containing S", then they
-- must be equal. The proof relies on the minimality property of each subgroup.
lemma uniqueness_of_smallest_normal_subgroup {G : Type*} [Group G] (S : Set G) (N₁ N₂ : Subgroup G)
    (h₁ : N₁.Normal ∧ S ⊆ ↑N₁ ∧ ∀ H : Subgroup G, H.Normal → S ⊆ ↑H → N₁ ≤ H)
    (h₂ : N₂.Normal ∧ S ⊆ ↑N₂ ∧ ∀ H : Subgroup G, H.Normal → S ⊆ ↑H → N₂ ≤ H) :
    N₁ = N₂ := by
  -- To prove equality of subgroups, we prove inclusion in both directions (antisymmetry).
  apply le_antisymm

  -- Part 1: Prove N₁ ≤ N₂.
  -- We use the minimality property of N₁, which is the third component of h₁.
  -- This property states that N₁ is a subgroup of any normal subgroup H that contains S.
  {
    -- Extract the properties of N₁ and N₂ from the hypotheses.
    rcases h₁ with ⟨_, _, h₁_minimal⟩
    rcases h₂ with ⟨h₂_normal, h₂_contains_S, _⟩
    -- N₂ is a normal subgroup containing S, so by the minimality of N₁, we have N₁ ≤ N₂.
    exact h₁_minimal N₂ h₂_normal h₂_contains_S
  }

  -- Part 2: Prove N₂ ≤ N₁.
  -- This is symmetric to the first part. We use the minimality property of N₂.
  {
    -- Extract the properties of N₂ and N₁ from the hypotheses.
    rcases h₂ with ⟨_, _, h₂_minimal⟩
    rcases h₁ with ⟨h₁_normal, h₁_contains_S, _⟩
    -- N₁ is a normal subgroup containing S, so by the minimality of N₂, we have N₂ ≤ N₁.
    exact h₂_minimal N₁ h₁_normal h₁_contains_S
  }

-- Sub-lemma 2: Existence.
-- This lemma shows that the subgroup `Subgroup.normalClosure S` satisfies the
-- properties of being a smallest normal subgroup containing S. Mathlib provides
-- direct lemmas for each of these properties.