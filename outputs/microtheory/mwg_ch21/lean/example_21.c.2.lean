import Mathlib

/-- The Condorcet Paradox: cyclic majority preferences with three voters and three alternatives. -/
theorem Example_21_C_2 :
    -- pref i a b = true means agent i strictly prefers a over b
    -- Agent 0: x(0) > y(1) > z(2)
    -- Agent 1: z(2) > x(0) > y(1)
    -- Agent 2: y(1) > z(2) > x(0)
    let pref : Fin 3 → Fin 3 → Fin 3 → Bool := fun i a b =>
      match i.val, a.val, b.val with
      | 0, 0, 1 => true | 0, 0, 2 => true | 0, 1, 2 => true
      | 1, 2, 0 => true | 1, 2, 1 => true | 1, 0, 1 => true
      | 2, 1, 2 => true | 2, 1, 0 => true | 2, 2, 0 => true
      | _, _, _ => false
    let votes : Fin 3 → Fin 3 → Nat := fun a b =>
      (Finset.univ.filter (fun i : Fin 3 => pref i a b)).card
    -- x beats y (2-1), y beats z (2-1), z beats x (2-1) — a cycle
    votes 0 1 ≥ 2 ∧ votes 1 2 ≥ 2 ∧ votes 2 0 ≥ 2 := by
  native_decide