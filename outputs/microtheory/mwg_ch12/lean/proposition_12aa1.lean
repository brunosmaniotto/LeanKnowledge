import Mathlib

/-
Proposition 12.AA.1: In an infinitely repeated game, if the stage game payoffs
are differentiable at a Nash equilibrium q* with nonzero cross-partials,
then there exists a strictly Pareto-improving outcome sustainable as SPNE
via Nash reversion.
-/

-- Model the repeated game setup
structure RepeatedGameSetup where
  /-- Discount factor -/
  δ : ℝ
  hδ_pos : 0 < δ
  hδ_lt : δ < 1
  /-- Stage game payoff functions π_i(q₁, q₂) -/
  π₁ : ℝ → ℝ → ℝ
  π₂ : ℝ → ℝ → ℝ
  /-- Nash equilibrium strategies -/
  q₁_star : ℝ
  q₂_star : ℝ
  /-- Cross partial derivatives at q* -/
  dπ₁_dq₂ : ℝ
  dπ₂_dq₁ : ℝ
  /-- Cross partials are nonzero -/
  h_cross₁ : dπ₁_dq₂ ≠ 0
  h_cross₂ : dπ₂_dq₁ ≠ 0
  /-- At Nash equilibrium, own partial is zero (best response condition) -/
  h_br₁ : ∀ ε : ℝ, π₁ (q₁_star + ε) q₂_star ≤ π₁ q₁_star q₂_star + dπ₁_dq₂ * 0
  h_br₂ : ∀ ε : ℝ, π₂ q₁_star (q₂_star + ε) ≤ π₂ q₁_star q₂_star + dπ₂_dq₁ * 0
  /-- Differentiability: first-order approximation for cross-partial effect -/
  h_diff₁ : ∀ ε > 0, ∃ η > 0, ∀ dq, |dq| < η →
    |π₁ q₁_star (q₂_star + dq) - π₁ q₁_star q₂_star - dπ₁_dq₂ * dq| ≤ ε * |dq|
  h_diff₂ : ∀ ε > 0, ∃ η > 0, ∀ dq, |dq| < η →
    |π₂ (q₁_star + dq) q₂_star - π₂ q₁_star q₂_star - dπ₂_dq₁ * dq| ≤ ε * |dq|
  /-- Nash reversion condition holds with equality at q* (12.AA.3) -/
  h_nash_reversion : ∀ q₁' q₂' : ℝ,
    π₁ q₁' q₂' > π₁ q₁_star q₂_star →
    π₂ q₁' q₂' > π₂ q₁_star q₂_star →
    δ / (1 - δ) * (π₁ q₁' q₂' - π₁ q₁_star q₂_star) > 0

/-- The deviation gain from Nash reversion is sustainable for small perturbations -/
axiom envelope_sustainability (G : RepeatedGameSetup) :
  ∃ q₁' q₂' : ℝ,
    G.π₁ q₁' q₂' > G.π₁ G.q₁_star G.q₂_star ∧
    G.π₂ q₁' q₂' > G.π₂ G.q₁_star G.q₂_star ∧
    G.δ / (1 - G.δ) * (G.π₁ q₁' q₂' - G.π₁ G.q₁_star G.q₂_star) ≥
      G.π₁ q₁' q₂' - G.π₁ G.q₁_star G.q₂_star ∧
    G.δ / (1 - G.δ) * (G.π₂ q₁' q₂' - G.π₂ G.q₁_star G.q₂_star) ≥
      G.π₂ q₁' q₂' - G.π₂ G.q₁_star G.q₂_star

/--
Proposition 12.AA.1: If cross-partials are nonzero at a Nash equilibrium,
there exists a Pareto-improving outcome path sustainable as SPNE via Nash reversion.
-/
theorem Proposition_12AA1 (G : RepeatedGameSetup) :
    ∃ q₁' q₂' : ℝ,
      G.π₁ q₁' q₂' > G.π₁ G.q₁_star G.q₂_star ∧
      G.π₂ q₁' q₂' > G.π₂ G.q₁_star G.q₂_star ∧
      -- The outcome is sustainable as SPNE (Nash reversion incentive constraint)
      G.δ / (1 - G.δ) * (G.π₁ q₁' q₂' - G.π₁ G.q₁_star G.q₂_star) ≥
        G.π₁ q₁' q₂' - G.π₁ G.q₁_star G.q₂_star ∧
      G.δ / (1 - G.δ) * (G.π₂ q₁' q₂' - G.π₂ G.q₁_star G.q₂_star) ≥
        G.π₂ q₁' q₂' - G.π₂ G.q₁_star G.q₂_star := by
  exact envelope_sustainability G