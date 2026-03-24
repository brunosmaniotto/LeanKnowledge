import Mathlib

-- This sub-lemma, provided in the problem description, states that the cardinality
-- of the type of embeddings from S to T is given by the descending factorial.
-- It is a direct wrapper around the Mathlib lemma `Fintype.card_embedding_eq`.
lemma card_embeddings_eq_descFactorial {S T : Type*} [Fintype S] [Fintype T] [DecidableEq T] :
    Fintype.card (S ↪ T) = (Fintype.card T).descFactorial (Fintype.card S) := by
  exact Fintype.card_embedding_eq

-- This sub-lemma expresses the descending factorial `n.descFactorial m`
-- in terms of factorials for `m ≤ n` and as 0 for `m > n`. This is necessary
-- to match the form of the main theorem's statement.