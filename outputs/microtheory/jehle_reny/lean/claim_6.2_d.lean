import Mathlib

/-- Majority voting fails transitivity: the Condorcet paradox with 3 voters and
    3 alternatives produces a majority cycle, ruling out majority voting as a
    social welfare function under unrestricted domain with transitive preferences. -/
theorem Claim_6_2_d : ∃ (pref : Fin 3 → Fin 3 → Fin 3 → Bool),
    -- Each voter has a strict linear order (irreflexive, transitive, total)
    (∀ i a, pref i a a = false) ∧
    (∀ i a b c, pref i a b = true → pref i b c = true → pref i a c = true) ∧
    (∀ i a b, a ≠ b → pref i a b = true ∨ pref i b a = true) ∧
    -- Majority voting produces a cycle: 0 beats 1, 1 beats 2, 2 beats 0
    ∃ a b c : Fin 3,
      (Finset.univ.filter fun i => pref i a b = true).card >
        (Finset.univ.filter fun i => pref i b a = true).card ∧
      (Finset.univ.filter fun i => pref i b c = true).card >
        (Finset.univ.filter fun i => pref i c b = true).card ∧
      (Finset.univ.filter fun i => pref i c a = true).card >
        (Finset.univ.filter fun i => pref i a c = true).card := by
  -- Condorcet preferences: voter 0: 0>1>2, voter 1: 1>2>0, voter 2: 2>0>1
  refine ⟨fun i a b => match i, a, b with
    | 0, 0, 1 => true | 0, 0, 2 => true | 0, 1, 2 => true
    | 1, 1, 2 => true | 1, 1, 0 => true | 1, 2, 0 => true
    | 2, 2, 0 => true | 2, 2, 1 => true | 2, 0, 1 => true
    | _, _, _ => false, ?_, ?_, ?_, 0, 1, 2, ?_, ?_, ?_⟩
  all_goals native_decide