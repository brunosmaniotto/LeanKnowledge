import Mathlib

-- This theorem states that the state code function for a Universal Register Machine (URM)
-- is primitive recursive. The function, S_k, takes a program code `e`, `k` inputs `n_1, ..., n_k`,
-- and a time step `t`, and returns the state code at that time.
--
-- A full formal proof is a major undertaking that requires building a library for URM computability
-- within Lean, including:
-- 1. Formalizing the encoding of programs and states.
-- 2. Proving that predicates for program validity (`is_prog`) and instruction types
--    (`is_zero`, `is_succ`, etc.) are primitive recursive.
-- 3. Proving that functions for decoding instructions and manipulating state codes
--    (e.g