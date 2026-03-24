import Mathlib
open Topology

/-- Majority rule is complete but fails transitivity (Condorcet's paradox). -/
theorem Claim_6_2_b :
    let pref : Fin 3 → Fin 3 → Fin 3 → Bool := fun i a b =>
      match i, a, b with
      -- Voter 0: x > y > z  (0 > 1 > 2)
      | 0, 0, 1 => true | 0, 0, 2 => true | 0, 1, 2 => true
      -- Voter 1: z > x > y  (2 > 0 > 1)
      | 1, 2, 0 => true | 1, 2, 1 => true | 1, 0, 1 => true
      -- Voter 2: y > z > x  (1 > 2 > 0)
      | 2, 1, 2 => true | 2, 1, 0 => true | 2, 2, 0 => true
      | _, _, _ => false
    let majority := fun (a b : Fin 3) =>
      2 ≤ (Finset.univ.filter (fun i => pref i a b = true)).card
    -- Completeness: every pair has a majority winner
    (∀ a b : Fin 3, a ≠ b → majority a b ∨ majority b a) ∧
    -- Cycle: x >_maj y >_maj z >_maj x
    (majority 0 1 ∧ majority 1 2 ∧ majority 2 0) ∧
    -- No global best alternative
    ¬∃ w : Fin 3, ∀ v : Fin 3, v ≠ w → majority w v := by
  native_decide