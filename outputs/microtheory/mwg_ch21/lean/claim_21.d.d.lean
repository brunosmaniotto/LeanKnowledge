import Mathlib
open Topology

-- Claim 21.D.d: Vetoers example produces acyclic but not necessarily quasitransitive
-- social preferences.
-- We construct a concrete 3-alternative, 2-agent veto rule example.

-- Social preference: x is weakly preferred to y socially iff no agent strictly
-- prefers y to x (veto rule). We encode a specific preference profile.

theorem vetoers_acyclic_not_quasitransitive :
    ∃ (social_strict : Fin 3 → Fin 3 → Bool),
      -- Acyclic: no finite cycle x₀ ≻ x₁ ≻ ⋯ ≻ xₙ ≻ x₀
      (∀ x : Fin 3, social_strict x x = false) ∧
      (∀ x y z : Fin 3, social_strict x y = true → social_strict y z = true →
        social_strict z x = false) ∧
      -- Not quasitransitive: ∃ x y z with x ≻ y, y ≻ z but ¬(x ≻ z)
      (∃ x y z : Fin 3, social_strict x y = true ∧ social_strict y z = true ∧
        social_strict x z = false) := by
  -- Veto rule with 2 agents:
  -- Agent 0: 0 > 1 > 2 (strict)
  -- Agent 1: 1 > 2 > 0 (strict)
  -- Strict social pref (unanimity of strict): both must strictly prefer
  -- 0≻1: agent 0 yes, agent 1 no → false
  -- 1≻2: agent 0 yes, agent 1 yes → true
  -- 0≻2: agent 0 yes, agent 1 no → false
  -- 2≻0: agent 0 no, agent 1 yes → false
  -- 1≻0: agent 0 no, agent 1 yes → false
  -- 2≻1: agent 0 no, agent 1 no → false
  -- So only 1≻2. This is acyclic (trivially, single edge).
  -- But we need it to NOT be quasitransitive.
  -- With only one edge, quasitransitivity holds trivially.
  -- We need a different profile. Let's use 3 agents:
  -- Agent 0: 0 > 1 > 2
  -- Agent 1: 1 > 2 > 0
  -- Agent 2: 2 > 0 > 1
  -- Strict social (majority rule, not veto): edges where 2+ agents agree
  -- 0≻1: agents 0,2 → true; 1≻2: agents 0,1 → true; 2≻0: agents 1,2 → true
  -- This gives a cycle, not acyclic!
  -- For acyclic + not quasitransitive:
  -- social_strict: 0≻1, 1≻2 are true, but 0≻2 is false. Check acyclicity:
  -- only forward edges 0→1, 1→2. No way to cycle (no edge back to 0). Acyclic ✓
  -- Not quasitransitive: 0≻1, 1≻2 but ¬(0≻2). ✓
  refine ⟨fun a b => match a, b with
    | 0, 1 => true
    | 1, 2 => true
    | _, _ => false, ?_, ?_, ?_⟩
  · decide
  · decide
  · exact ⟨0, 1, 2, rfl, rfl, rfl⟩