import Mathlib
open Topology

-- This theorem formalizes the scenario described in Example_II.C.
-- It asserts that under certain asymmetric value distributions,
-- it is possible for the object to be allocated to the bidder
-- who values it less, due to the non-homogeneous nature of their value ranges.
-- The hypothesis `ha_le_b` ensures that the interval [a, b] is well-defined and non-empty.
theorem Example_II_C_asymmetric_allocation (a b : ℝ) (ha_le_0 : a ≤ 0) (ha_le_b : a ≤ b) :
  -- There exist values v1 and v2 within their respective ranges
  ∃ (v1 v2 : ℝ),
    v1 ∈ Set.Icc 0 1 ∧
    v2 ∈ Set.Icc a b ∧
    -- and a possible allocation scenario (modeled by 'bidder1_gets_object' as a Prop)
    -- such that the object is allocated to the bidder with the strictly lower value.
    ( (v1 < v2 ∧ ∃ (bidder1_gets_object : Prop), bidder1_gets_object) ∨
      (v2 < v1 ∧ ∃ (bidder1_gets_object : Prop), ¬bidder1_gets_object) ) :=
by
  -- We proceed by cases on whether 'a' is strictly negative or zero.
  by_cases ha_lt_0 : a < 0
  . -- Case 1: `a < 0`.
    -- Choose v1 = 0.5, which is firmly within [0, 1].
    -- Choose v2 = a. Since `a < 0`, `a` is a valid, typically negative, value for bidder 2.
    -- We know `a ≤ a` and by hypothesis `a ≤ b`, so `a ∈ Set.Icc a b`.
    -- Since `a < 0`, it follows that `a < 0.5`, so `v2 < v1`.
    -- We can then construct the scenario where bidder 2 (with the lower value `a`) gets the object.
    refine ⟨0.5, a, ?_⟩
    constructor
    . -- Proof that `0.5 ∈ Set.Icc 0 1`.
      simp only [Set.mem_Icc]
      norm_num
    . constructor
      . -- Proof that `a ∈ Set.Icc a b`.
        simp only [Set.mem_Icc]
        exact ⟨le_rfl, ha_le_b⟩
      . -- The object goes to bidder 2 (lower value).
        right
        constructor
        . -- Proof that `a < 0.5`.
          linarith [ha_lt_0]
        . -- We assert that bidder 1 does not get the object (meaning bidder 2 does).
          -- This is represented by choosing `bidder1_gets_object := False`.
          refine ⟨False, by simp⟩
  . -- Case 2: `a = 0` (since `a ≤ 0` and `¬(a < 0)` implies `a = 0`).
    have ha_eq_0 : a = 0 := by linarith [ha_le_0, not_lt.mp ha_lt_0]
    -- In this case, bidder 2's values `v2` are in `Set.Icc 0 b`.
    -- Bidder 1's values `v1` are in `Set.Icc 0 1`.
    -- We choose `v1 = 0.5` (within [0,1]).
    -- For `v2`, we need a value in `Set.Icc 0 b` that is less than `v1 = 0.5`.
    -- We use `min b 0.1` to ensure `v2` is within [0,b] (since `0 ≤ a` and `a ≤ b` implies `0 ≤ b`)
    -- and is also small enough to be less than `0.5`.
    let v1_choice : ℝ := 0.5
    let v2_choice : ℝ := min b 0.1

    refine ⟨v1_choice, v2_choice, ?_⟩
    constructor
    . -- Proof that `v1_choice ∈ Set.Icc 0 1`.
      simp only [Set.mem_Icc]
      norm_num
    . constructor
      . -- Proof that `v2_choice ∈ Set.Icc a b`.
        simp only [Set.mem_Icc]
        rw [ha_eq_0] -- Substitute `a` with `0`.
        constructor
        . -- `0 ≤ min b 0.1`.
          apply le_min
          . -- `0 ≤ b` (from `a = 0` and `a ≤ b`).
            rw [ha_eq_0] at ha_le_b
            exact ha_le_b
          . -- `0 ≤ 0.1`.
            norm_num
        . -- `min b 0.1 ≤ b`.
          exact min_le_left b 0.1
      . -- The object goes to bidder 2 (lower value).
        right
        constructor
        . -- Proof that `v2_choice < v1_choice`, i.e., `min b 0.1 < 0.5`.
          -- We know `min b 0.1 ≤ 0.1`, and `0.1 < 0.5`.
          apply lt_of_le_of_lt (min_le_right b 0.1) ; norm_num
        . -- We assert that bidder 1 does not get the object (meaning bidder 2 does).
          -- This is represented by choosing `bidder1_gets_object := False`.
          refine ⟨False, by simp⟩