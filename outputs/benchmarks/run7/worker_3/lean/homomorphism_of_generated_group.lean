import Mathlib

-- Let G and H be groups, and let φ and ψ be homomorphisms from G to H.
-- The equalizer of φ and ψ, `MonoidHom.eqLocus φ ψ`, is the subgroup of G
-- consisting of all elements `g` where `φ g = ψ g`.

-- Sub-lemma 1: The closure of a set S is a subgroup of the equalizer if the
-- homomorphisms agree on all elements of S.
lemma closure_le_eqLocus_of_agree_on_generators {G H : Type*} [Group G] [Group H] {S : Set G} {φ ψ : G →* H} (h_agree : ∀ x ∈ S, φ x = ψ x) : Subgroup.closure S ≤ MonoidHom.eqLocus φ ψ := by
  -- The lemma `Subgroup.closure_le` states that for a subgroup `K`, `Subgroup.closure S ≤ K`
  -- is equivalent to `S` being a subset of `K`. We use `rw` to apply this equivalence.
  rw [Subgroup.closure_le]
  -- The goal is now to prove `S ⊆ ↑(MonoidHom.eqLocus φ ψ)`.
  -- This means we must show that every element of `S` is in the equalizer.
  -- By definition of `MonoidHom.eqLocus`, an element `x` is in the equalizer
  -- if and only if `φ x = ψ x`.
  -- So, the goal is `∀ x ∈ S, φ x = ψ x`, which is exactly our hypothesis `h_agree`.
  exact h_agree

-- Sub-lemma 2: If the equalizer of two homomorphisms is the entire group (⊤),
-- then the homomorphisms are equal.