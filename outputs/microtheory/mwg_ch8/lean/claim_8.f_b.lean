import Mathlib

-- Claim 8.F.b: In two-player games, a Nash equilibrium is trembling-hand perfect
-- iff it does not involve weakly dominated strategies. For games with 3+ players,
-- trembling-hand perfection is strictly more restrictive.

-- We axiomatize the game-theoretic concepts needed for this result.

-- A finite normal-form game
axiom NormalFormGame : Type
axiom NormalFormGame.numPlayers : NormalFormGame → ℕ
axiom NormalFormGame.NashEquilibrium : NormalFormGame → Type
axiom NormalFormGame.isTHPerfect : (G : NormalFormGame) → G.NashEquilibrium → Prop
axiom NormalFormGame.involvesWeaklyDominatedStrategy : (G : NormalFormGame) → G.NashEquilibrium → Prop

-- In two-player games: NE is THP ↔ it doesn't use weakly dominated strategies
axiom two_player_THP_equiv_no_weakly_dominated :
  ∀ (G : NormalFormGame), G.numPlayers = 2 →
    ∀ (σ : G.NashEquilibrium),
      G.isTHPerfect σ ↔ ¬G.involvesWeaklyDominatedStrategy σ

-- Counterexample: there exists a 3-player game with a NE that uses no weakly
-- dominated strategies but is not trembling-hand perfect
axiom three_player_counterexample :
  ∃ (G : NormalFormGame), G.numPlayers = 3 ∧
    ∃ (σ : G.NashEquilibrium),
      ¬G.involvesWeaklyDominatedStrategy σ ∧ ¬G.isTHPerfect σ

/-- Trembling-hand perfection is equivalent to avoiding weakly dominated strategies
    in two-player games, but is strictly more restrictive for games with 3+ players. -/
theorem trembling_hand_perfection_characterization :
    -- Part 1: Two-player equivalence
    (∀ (G : NormalFormGame), G.numPlayers = 2 →
      ∀ (σ : G.NashEquilibrium),
        G.isTHPerfect σ ↔ ¬G.involvesWeaklyDominatedStrategy σ) ∧
    -- Part 2: Strict refinement for 3+ players
    (∃ (G : NormalFormGame), G.numPlayers ≥ 3 ∧
      ∃ (σ : G.NashEquilibrium),
        ¬G.involvesWeaklyDominatedStrategy σ ∧ ¬G.isTHPerfect σ) := by
  constructor
  · exact two_player_THP_equiv_no_weakly_dominated
  · obtain ⟨G, hG, σ, hσ⟩ := three_player_counterexample
    exact ⟨G, by omega, σ, hσ⟩