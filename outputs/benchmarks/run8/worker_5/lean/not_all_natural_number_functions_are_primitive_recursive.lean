import Mathlib

-- Axiomatized sub-lemmas (given as facts)

-- The set of primitive recursive functions from ℕ to ℕ is countable.
axiom countable_primrec_functions : Countable { f : ℕ → ℕ // Primrec f }

-- The set of all functions from ℕ to ℕ is uncountable.
axiom uncountable_all_nat_functions : ¬ Countable (ℕ → ℕ)

-- If all functions are primitive recursive, then the type of all functions is
-- equivalent to the subtype of primitive recursive functions.
axiom equiv_all_functions_to_primrec_subtype (h_all_primrec : ∀ f : ℕ → ℕ, Primrec f) :
  (ℕ → ℕ) ≃ { f : ℕ → ℕ // Primrec f }

-- Main theorem: Not all natural number functions are primitive recursive.
-- This is a classic application of Cantor's diagonal argument. The set of
-- primitive recursive functions is countable, but the set of all functions
-- from ℕ to ℕ is uncountable. Therefore, there must be functions that are
-- not primitive recursive.
theorem not_all_nat_functions_are_prim_rec : ∃ f : ℕ → ℕ, ¬ Primrec f := by
  -- We prove this by contradiction. Assume the negation of the goal.
  by_contra h_neg
  -- The negation of `∃ f, ¬Primrec f` is `∀ f, Primrec f`.
  push_neg at h_neg
  -- From our assumption `h_neg`, we can use the provided axiom to get an
  -- equivalence between the type of all functions and the subtype of
  -- primitive recursive functions.
  have equiv_all_to_primrec : (ℕ → ℕ) ≃ { f : ℕ → ℕ // Primrec f } :=
    equiv_all_functions_to_primrec_subtype h_neg
  -- By axiom, the set of primitive recursive functions is countable.
  have h_primrec_countable : Countable { f : ℕ → ℕ // Primrec f } :=
    countable_primrec_functions
  -- An equivalence preserves countability. Since the subtype of primitive
  -- recursive functions is countable, the type of all functions must also be.
  have h_all_countable : Countable (ℕ → ℕ) :=
    equiv_all_to_primrec.countable_iff.mpr h_primrec_countable
  -- By another axiom, the set of all functions is uncountable.
  have h_all_uncountable : ¬ Countable (ℕ → ℕ) :=
    uncountable_all_nat_functions
  -- This is a contradiction: we have derived that `Countable (ℕ → ℕ)` is
  -- both true and false.
  exact h_all_uncountable h_all_countable