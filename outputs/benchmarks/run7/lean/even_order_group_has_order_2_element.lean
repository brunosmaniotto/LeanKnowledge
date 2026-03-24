import Mathlib

-- This single import is sufficient for all the necessary theories,
-- including groups, finite types, order of elements, and Sylow's theorems.

-- Sub-lemma 1: An even number is divisible by 2.
-- This connects the `Even` property with divisibility.
lemma even_imp_two_dvd {n : ℕ} (h : Even n) : 2 ∣ n := by
  -- The lemma `even_iff_two_dvd` states the equivalence `Even n ↔ 2 ∣ n`.
  -- We use its forward direction, `.mp` (for "modus ponens"), to prove the goal.
  exact even_iff_two_dvd.mp h

-- Sub-lemma 2: Cauchy's theorem for p=2.
-- If 2 divides the order of a group G, then there exists an element of order 2.