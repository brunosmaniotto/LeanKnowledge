import Mathlib

-- This sub-lemma proves that if two finite types have the same cardinality,
-- then there exists an equivalence between them.
lemma equiv_of_same_cardinality {n : ℕ} {ι κ : Type*} [Fintype ι] [Fintype κ] (hι : Fintype.card ι = n) (hκ : Fintype.card κ = n) : Nonempty (ι ≃ κ) := by
  -- First, we establish that the cardinalities of ι and κ are equal.
  have h_card_eq : Fintype.card ι = Fintype.card κ := by
    -- We are given `Fintype.card ι = n` and `Fintype.card κ = n`.
    -- By rewriting with these hypotheses, we get `n = n`, which is true.
    simp [hι, hκ]
  -- `Fintype.equivOfCardEq` constructs an equivalence given equal cardinalities.
  -- We wrap it in `Nonempty.intro` (using `⟨...⟩` notation) to prove `Nonempty`.
  exact ⟨Fintype.equivOfCardEq h_card_eq⟩

-- Main theorem: Any two unitary R-modules having bases of n elements are isomorphic.
-- A basis of `n` elements means the basis is indexed by a finite type `ι`
-- with `Fintype.card ι = n`.