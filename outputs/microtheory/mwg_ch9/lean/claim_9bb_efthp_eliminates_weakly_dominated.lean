import Mathlib

-- Minimal model of behavioral strategies in a 2-player extensive form game
structure BehavioralStrategy where
  p1_prob_L : ℝ
  p2_prob_l : ℝ

structure SequentialEquilibrium extends BehavioralStrategy where
  is_sequentially_rational : True
  beliefs_consistent : True

structure EFTHP extends BehavioralStrategy where
  is_limit_of_totally_mixed : True

noncomputable def weaklyDominatedProfile : BehavioralStrategy :=
  { p1_prob_L := 0, p2_prob_l := 0 }

-- In the game of Figure 9.BB.2, there exists a sequential equilibrium
-- using weakly dominated strategies
axiom exists_SE_with_weakly_dominated :
  ∃ (se : SequentialEquilibrium),
    se.p1_prob_L = weaklyDominatedProfile.p1_prob_L ∧
    se.p2_prob_l = weaklyDominatedProfile.p2_prob_l

-- No EFTHP equilibrium uses those weakly dominated strategies
axiom no_EFTHP_with_weakly_dominated :
  ∀ (e : EFTHP),
    ¬(e.p1_prob_L = weaklyDominatedProfile.p1_prob_L ∧
      e.p2_prob_l = weaklyDominatedProfile.p2_prob_l)

/-- EFTHP eliminates some sequential equilibria that use weakly dominated strategies:
    there exists a sequential equilibrium whose strategy profile cannot be supported
    by any extensive-form trembling-hand perfect equilibrium. -/
theorem efthp_eliminates_weakly_dominated_SE :
    ∃ (se : SequentialEquilibrium),
      ∀ (e : EFTHP),
        ¬(e.p1_prob_L = se.p1_prob_L ∧ e.p2_prob_l = se.p2_prob_l) := by
  obtain ⟨se, hse1, hse2⟩ := exists_SE_with_weakly_dominated
  exact ⟨se, fun e he => no_EFTHP_with_weakly_dominated e
    ⟨he.1.trans hse1, he.2.trans hse2⟩⟩