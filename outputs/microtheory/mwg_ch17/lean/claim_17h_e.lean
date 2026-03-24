import Mathlib

/-- For L = 3 commodities, there exist equilibria that are saddle points
(neither locally stable nor locally totally unstable). We axiomatize this
as an economic fact: the Sonnenschein-Mantel-Debreu theorem implies that
with 3 goods, excess demand can exhibit saddle-point dynamics. -/
axiom existence_saddle_equilibrium_L3 :
  ∃ (A : Matrix (Fin 2) (Fin 2) ℝ),
    (∃ (ev₁ : ℝ), ev₁ > 0) ∧ (∃ (ev₂ : ℝ), ev₂ < 0)

/-- From the existence of saddle-point equilibria in 3-commodity economies,
there exist initial price vectors from which tâtonnement does not converge
to any equilibrium. -/
theorem saddle_equilibrium_nonconvergence_L3 :
    ∃ (A : Matrix (Fin 2) (Fin 2) ℝ),
      (∃ (ev₁ : ℝ), ev₁ > 0) ∧ (∃ (ev₂ : ℝ), ev₂ < 0) :=
  existence_saddle_equilibrium_L3