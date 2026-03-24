import Mathlib

-- Axiomatized sub-lemmas (given as facts for this proof)

axiom sSup_scaled_le_scaled_sSup (S : Set ℝ) (hS_nonempty : S.Nonempty) (hS_bdd : BddAbove S) (z : ℝ) (hz : 0 < z) : sSup ((fun x => z * x) '' S) ≤ z * sSup S
axiom scaled_sSup_le_sSup_scaled (S : Set ℝ) (hS_nonempty : S.Nonempty) (hS_bdd : BddAbove S) (z : ℝ) (hz : 0 < z) : z * sSup S ≤ sSup ((fun x => z * x) '' S)

-- Main theorem: Multiple of Supremum

/--
Let $S \subseteq \R$ be a non-empty, bounded-above set of real numbers, and let $z > 0$.
Then the supremum of the set $\{zx \mid x \in S\}$ is equal to $z$ times the supremum of $S$.
-/
theorem multiple_of_supremum (S : Set ℝ) (hS_nonempty : S.Nonempty) (hS_bdd : BddAbove S) (z : ℝ) (hz : 0 < z) :
  sSup ((fun x => z * x) '' S) = z * sSup S := by
  -- To prove the equality, we use the principle of antisymmetry, which states that
  -- for any two real numbers `a` and `b`, if `a ≤ b` and `b ≤ a`, then `a = b`.
  -- We are given the two required inequalities as axioms.

  -- First, we have that the supremum of the scaled set is less than or equal to the scaled supremum.
  have h_le := sSup_scaled_le_scaled_sSup S hS_nonempty hS_bdd z hz

  -- Second, we have the reverse inequality.
  have h_ge := scaled_sSup_le_sSup_scaled S hS_nonempty hS_bdd z hz

  -- Combining these two inequalities gives the desired equality.
  exact le_antisymm h_le h_ge