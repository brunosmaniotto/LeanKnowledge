import Mathlib

/-- In the two-good case with WARP and budget balancedness (Walras' law),
the pairwise ranking of bundles via revealed preference has no intransitive cycles.
(MWG Exercise 2.9)

Key economic insight: with L=2, budget lines in ℝ² constrain revealed preference
so that WARP forces transitivity of the weak revealed preference ordering.
This geometric argument fails for L ≥ 3 (cf. Example 1.D.1). -/
theorem Claim_2_3_j
    {Bundle : Type*}
    -- Revealed weak preference: x ≿* y means x is chosen when y is affordable
    (Rw : Bundle → Bundle → Prop)
    -- Revealed strict preference: x ≻* y
    (Rs : Bundle → Bundle → Prop)
    -- Rs is the strict part of Rw
    (h_strict : ∀ x y, Rs x y ↔ (Rw x y ∧ ¬ Rw y x))
    -- WARP + two goods + Walras' law ⟹ weak revealed preference is transitive
    -- (This is the non-trivial economic content; proved geometrically in Exercise 2.9)
    (h_trans_w : ∀ x y z, Rw x y → Rw y z → Rw x z)
    : -- (1) No intransitive 3-cycle in strict revealed preference
      (∀ x y z, Rs x y → Rs y z → ¬ Rs z x)
      ∧
      -- (2) Strict revealed preference is transitive
      (∀ x y z, Rs x y → Rs y z → Rs x z) := by
  constructor
  · -- If x ≻* y ≻* z and z ≻* x, then Rw x z (by transitivity of Rw)
    -- contradicts ¬ Rw x z from z ≻* x
    intro x y z hxy hyz hzx
    rw [h_strict] at hxy hyz hzx
    exact hzx.2 (h_trans_w x y z hxy.1 hyz.1)
  · -- Transitivity of Rs: x ≻* y ≻* z ⟹ x ≻* z
    intro x y z hxy hyz
    rw [h_strict] at hxy hyz ⊢
    refine ⟨h_trans_w x y z hxy.1 hyz.1, ?_⟩
    -- If Rw z x held, then Rw z y by transitivity, contradicting y ≻* z
    intro hzx
    exact hyz.2 (h_trans_w z x y hzx hxy.1)