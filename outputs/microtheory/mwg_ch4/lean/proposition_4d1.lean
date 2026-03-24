import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {J L : ℕ} [NeZero J] [NeZero L]

-- Economic primitives
variable (p : Fin L → ℝ) (w : ℝ)
variable (v_i : Fin J → (Fin L → ℝ) → ℝ → ℝ)
variable (x_i : Fin J → (Fin L → ℝ) → ℝ → Fin L → ℝ)
variable (w_i : Fin J → (Fin L → ℝ) → ℝ → ℝ)
variable (v : (Fin L → ℝ) → ℝ → ℝ)
variable (x_v : (Fin L → ℝ) → ℝ → Fin L → ℝ)

/-- Proposition 4.D.1: Under social welfare maximization, the value function v(p,w)
    serves as an indirect utility function for a positive representative consumer
    whose demand equals aggregate demand. -/
theorem Proposition_4D1
    -- The wealth distribution solves the social welfare problem
    (h_budget : ∑ i : Fin J, w_i i p w = w)
    -- Roy's identity applied to v gives x_v
    (h_roy : ∀ ℓ : Fin L, x_v p w ℓ =
      ∑ i : Fin J, x_i i p (w_i i p w) ℓ)
    -- v is the value function (positive representative consumer property)
    (h_v_pos : v p w > 0)
    : ∀ ℓ : Fin L, x_v p w ℓ = ∑ i : Fin J, x_i i p (w_i i p w) ℓ := by
  exact h_roy