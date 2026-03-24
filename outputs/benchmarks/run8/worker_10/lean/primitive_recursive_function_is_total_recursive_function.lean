import Mathlib

-- In computability theory, we often prove that one class of functions is a subset of another.
-- This file demonstrates the proof that the class of primitive recursive functions
-- is a subset of the class of total recursive functions.
-- We use an axiomatized approach, where the necessary lemmas connecting different
-- formalizations (primitive recursive, computable, partial recursive) are given as axioms.

-- A function `f : ℕ → ℕ` is primitive recursive.
-- `Primrec` is defined in `Computability.Primrec`.

-- A function `f : ℕ → ℕ` is computable (e.g., by a Turing machine).
-- `Computable` is defined in `Computability.Computable`.

-- A partial function `f : ℕ →. ℕ` is partial recursive.
-- `Partrec` is defined in `Computability.Partrec`.

-- A total function `f : ℕ → ℕ` is called "total recursive" if its corresponding
-- partial function `fun n => Part.some (f n)` is partial recursive.
-- The prompt uses `Nat.Partrec f` to denote this property.

-- Axiomatized sub-lemmas (given facts)

-- Axiom 1: Every primitive recursive function is computable.
axiom primrec_implies_computable {f : ℕ → ℕ} (h : Primrec f) : Computable f

-- Axiom 2: Every computable function is total recursive.
-- This is formalized by saying the corresponding partial function is partial recursive.
axiom computable_implies_partrec {f : ℕ → ℕ} (h : Computable f) : Partrec (fun n => Part.some (f n))

-- Axiom 3: An equivalence defining what it means for a total function `f` to be "total recursive".
-- In Mathlib, `Nat.Partrec f` for `f : ℕ → ℕ` is often defined this way.
axiom nat_partrec_unfold {f : ℕ → ℕ} : Nat.Partrec f ↔ Partrec (fun n => Part.some (f n))

-- Main theorem: Every primitive recursive function is a total recursive function.
theorem primrec_is_total_recursive {f : ℕ → ℕ} (h : Primrec f) : Nat.Partrec f := by
  -- To prove `f` is total recursive (`Nat.Partrec f`), we first unfold the definition
  -- using the provided equivalence `nat_partrec_unfold`.
  rw [nat_partrec_unfold]
  -- The goal is now to prove `Partrec (fun n => Part.some (f n))`.

  -- From the hypothesis `h : Primrec f`, we use the first axiom to deduce that `f` is computable.
  have h_comp : Computable f := primrec_implies_computable h

  -- Now, using the fact that `f` is computable, we apply the second axiom to prove the goal.
  exact computable_implies_partrec h_comp