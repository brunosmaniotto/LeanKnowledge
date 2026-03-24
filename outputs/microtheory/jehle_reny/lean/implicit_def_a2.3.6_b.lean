import Mathlib

open Finset BigOperators

/-- **Complementary slackness** (MWG Definition A2.3.6(b)).
    Given Lagrange multipliers `μ : Fin m → ℝ` and constraint values `g(x*) : Fin m → ℝ`,
    complementary slackness holds when `μ_j · g_j(x*) = 0` for every constraint `j`.
    Equivalently: if a constraint is slack (`g_j(x*) < 0`), then `μ_j = 0`;
    if `μ_j > 0`, then `g_j(x*) = 0`. -/
def ComplementarySlackness {m : ℕ} (mu : Fin m → ℝ) (g_star : Fin m → ℝ) : Prop :=
  ∀ j : Fin m, mu j * g_star j = 0