import Mathlib
open Topology

/-- Condorcet's paradox: majority rule over 3 voters with cyclic preferences
    produces a cyclic (non-transitive) social preference. -/
theorem Example_6_2_a :
    -- Define strict prefs as Bool functions for 3 voters over 3 alternatives
    -- Person 1: x > y > z, Person 2: y > z > x, Person 3: z > x > y
    -- Majority rule: a P b iff |{i : pref i a b}| ≥ 2
    -- We show: xPy ∧ yPz ∧ zPx (a cycle, violating transitivity)
    let pref : Fin 3 → Fin 3 → Fin 3 → Bool :=
      fun i a b => match i.val, a.val, b.val with
        | 0, 0, 1 => true  -- person 1: x > y
        | 0, 0, 2 => true  -- person 1: x > z
        | 0, 1, 2 => true  -- person 1: y > z
        | 1, 1, 2 => true  -- person 2: y > z
        | 1, 1, 0 => true  -- person 2: y > x
        | 1, 2, 0 => true  -- person 2: z > x
        | 2, 2, 0 => true  -- person 3: z > x
        | 2, 2, 1 => true  -- person 3: z > y
        | 2, 0, 1 => true  -- person 3: x > y
        | _, _, _ => false
    let majority := fun a b =>
      2 ≤ (Finset.univ.filter (fun i => pref i a b)).card
    -- xPy, yPz, zPx all hold, and xPz fails → cycle
    majority 0 1 ∧ majority 1 2 ∧ majority 2 0 ∧ ¬majority 0 2 := by
  native_decide