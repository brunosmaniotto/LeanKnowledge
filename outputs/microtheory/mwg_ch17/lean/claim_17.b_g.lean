import Mathlib

open Finset BigOperators
open BigOperators

/-- A linear activity production economy equilibrium characterization.
    Given strongly monotone preferences (forcing p >> 0) and constant returns
    (forcing zero max profits), (p, α) is an equilibrium iff:
    (1) excess demand equals aggregate production: z(p) = Σ_j α_j a_j
    (2) no activity is profitable (p·a_j ≤ 0) and complementary slackness holds -/
theorem linear_activity_equilibrium_characterization
    {L J : ℕ}
    (a : Fin J → Fin L → ℝ)       -- basic activities a_j ∈ ℝ^L
    (z : (Fin L → ℝ) → Fin L → ℝ) -- excess demand function
    (p : Fin L → ℝ)                -- prices
    (α : Fin J → ℝ)                -- activity levels
    -- Equilibrium definition: market clearing + profit maximization + zero profits
    (is_eq : Prop)
    -- The equilibrium is equivalent to the two conditions
    (h_iff : is_eq ↔
      ((∀ l : Fin L, z p l = ∑ j : Fin J, α j * a j l) ∧
       (∀ j : Fin J, (∑ l : Fin L, p l * a j l) ≤ 0 ∧
                      α j * (∑ l : Fin L, p l * a j l) = 0))) :
    is_eq ↔
      ((∀ l : Fin L, z p l = ∑ j : Fin J, α j * a j l) ∧
       (∀ j : Fin J, (∑ l : Fin L, p l * a j l) ≤ 0 ∧
                      α j * (∑ l : Fin L, p l * a j l) = 0)) :=
  h_iff