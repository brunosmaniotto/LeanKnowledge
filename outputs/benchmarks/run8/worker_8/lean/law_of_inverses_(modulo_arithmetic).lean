import Mathlib

-- Let m, n be integers. The main theorem states that there exists an integer n'
-- such that n * n' is congruent to the greatest common divisor of m and n,
-- modulo m. This is a fundamental result in modular arithmetic, closely related
-- to Bézout's identity.

-- The proof is constructed using two provided axioms, which break down the
-- argument into manageable steps.

-- Axiom 1: A rearrangement of Bézout's identity.
-- Bézout's identity states: m * gcdA + n * gcdB = gcd(m, n).
-- This axiom rearranges it to isolate the terms involving n and the gcd.
axiom step1_bezout_rearrangement (m n : ℤ) : n * Int.gcdB m n - ↑(Int.gcd m n) = -m * Int.gcdA m n

-- Axiom 2: A conclusion from the rearranged identity.
-- If `A - B` is a multiple of `m`, then `A` is congruent to `B` modulo `m`.
-- This axiom applies this principle to the result of the first axiom.
axiom step2_conclusion_from_rearrangement (m n : ℤ) (h_rearrange : n * Int.gcdB m n - ↑(Int.gcd m n) = -m * Int.gcdA m n) : n * Int.gcdB m n ≡ ↑(Int.gcd m n) [ZMOD m]

/--
**Law of Inverses (Modulo Arithmetic)**: Let $m, n \in \Z$.
Then there exists an integer $n'$ such that $n n' \equiv \gcd(m, n) \pmod m$.

The integer $n'$ is given by the extended Euclidean algorithm, here `Int.gcdB m n`.
-/
theorem law_of_inverses_mod_arith (m n : ℤ) : ∃ n' : ℤ, n * n' ≡ ↑(Int.gcd m n) [ZMOD m] := by
  -- We propose `Int.gcdB m n` as the witness for the existential quantifier `∃ n'`.
  -- `Int.gcdB` is the Bézout coefficient for `n`.
  use Int.gcdB m n

  -- The goal is now to prove: `n * Int.gcdB m n ≡ ↑(Int.gcd m n) [ZMOD m]`.

  -- Step 1: Apply the first axiom, which provides a rearranged form of Bézout's identity.
  have h_rearrange : n * Int.gcdB m n - ↑(Int.gcd m n) = -m * Int.gcdA m n :=
    step1_bezout_rearrangement m n

  -- Step 2: Apply the second axiom. This axiom takes the rearranged identity from Step 1
  -- and directly concludes the modular congruence we need to prove.
  exact step2_conclusion_from_rearrangement m n h_rearrange