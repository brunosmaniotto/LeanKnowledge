import Mathlib

-- Sub-lemma 1: strict monotonicity implies order embedding for linear orders
lemma strict_mono_order_embedding_of_linear {S T : Type*} [LinearOrder S] [PartialOrder T] 
    (f : S → T) (hf : StrictMono f) : ∀ a b, f a ≤ f b ↔ a ≤ b := by
  intro a b
  constructor
  · -- Forward direction: f a ≤ f b → a ≤ b
    intro h
    by_contra hab
    -- If a ≰ b, then b < a by linearity
    have hba : b < a := lt_of_not_ge hab
    -- By strict monotonicity, f b < f a
    have : f b < f a := hf hba
    -- This contradicts f a ≤ f b
    exact lt_irrefl (f a) (lt_of_le_of_lt h this)
  · -- Reverse direction: a ≤ b → f a ≤ f b
    intro hab
    cases' le_iff_eq_or_lt.mp hab with h h
    · -- Case: a = b
      rw [h]
    · -- Case: a < b
      exact le_of_lt (hf h)

-- Sub-lemma 2: equivalence of different formulations of order embedding