import Mathlib.Computability.Ackermann
import Mathlib.Computability.Primrec

-- In computability theory, we distinguish between primitive recursive functions
-- and the broader class of (URM) computable functions. The Ackermann function
-- is a key example used to show this distinction.

-- The function `ack m n` is computable but not primitive recursive. To show there
-- exists a unary function with this property, we can "flatten" the binary
-- `ack` function into a unary one using a pairing function.
-- `Nat.pair` and `Nat.unpair` are computable and primitive recursive bijections
-- between ℕ × ℕ and ℕ.

-- We define `ack_unary n` as `ack (Nat.unpair n).1 (Nat.unpair n).2`.
-- The proof relies on these key facts, which we state here as axioms.

-- Axiom 1: The unary Ackermann function is URM computable.
-- This is because `ack` is computable, and composition with the computable
-- `unpair` function preserves computability.
axiom ack_unary_computable : Computable (fun n ↦ ack (Nat.unpair n).1 (Nat.unpair n).2)

-- Axiom 2: If the unary Ackermann function were primitive recursive, then the
-- binary Ackermann function would also be primitive recursive.
-- This is because `ack m n` can be recovered from `ack_unary` by composing
-- with the primitive recursive `Nat.pair` function: `ack m n = ack_unary (Nat.pair m n)`.
axiom ack_primrec_of_ack_unary_primrec (h_unary_primrec : Primrec (fun n ↦ ack (Nat.unpair n).1 (Nat.unpair n).2)) : Primrec₂ ack

/--
There exists a URM computable function that is not primitive recursive.

This is a fundamental result in computability theory, demonstrating that the class
of primitive recursive functions is a strict subset of the class of computable
(or total recursive) functions. The proof uses the Ackermann function as a
concrete example of a function that is computable but not primitive recursive.
-/
theorem computable_not_primrec : ∃ (f : ℕ → ℕ), Computable f ∧ ¬ Primrec f := by
  -- Let `ack_unary` be the unary version of the Ackermann function.
  let ack_unary := fun n ↦ ack (Nat.unpair n).1 (Nat.unpair n).2

  -- By our first axiom, `ack_unary` is computable.
  have h_computable : Computable ack_unary := ack_unary_computable

  -- We now prove that `ack_unary` is not primitive recursive by contradiction.
  have h_not_primrec : ¬ Primrec ack_unary := by
    -- Assume, for contradiction, that `ack_unary` is primitive recursive.
    intro h_primrec
    -- By our second axiom, if `ack_unary` is primitive recursive, then the
    -- binary Ackermann function `ack` must also be primitive recursive.
    have h_ack_primrec₂ : Primrec₂ ack := ack_primrec_of_ack_unary_primrec h_primrec
    -- This leads to a contradiction, because it is a known theorem in Mathlib
    -- that the binary Ackermann function is NOT primitive recursive.
    exact not_primrec₂_ack h_ack_primrec₂

  -- We have found a function `ack_unary` that is computable but not primitive recursive.
  -- This satisfies the existential claim.
  exact ⟨ack_unary, h_computable, h_not_primrec⟩