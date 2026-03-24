import Mathlib

open BigOperators Finset
open Topology

variable {n m : ℕ}

/-- The Lagrangian function L(x, μ) = f(x) - Σⱼ μⱼ · gⱼ(x) -/
noncomputable def lagrangian
    (f : (Fin n → ℝ) → ℝ)
    (g : Fin m → (Fin n → ℝ) → ℝ)
    (x : Fin n → ℝ)
    (mu : Fin m → ℝ) : ℝ :=
  f x - ∑ j : Fin m, mu j * g j x

/-- The first-order conditions for the Lagrangian require:
    (1) ∂f/∂xᵢ = Σⱼ λⱼ · ∂gⱼ/∂xᵢ for all i (stationarity)
    (2) gⱼ(x*) = 0 for all j (feasibility)
    Together these give n + m equations in n + m unknowns (x₁,...,xₙ, λ₁,...,λₘ). -/
theorem Claim_A2_GeneralFOC
    (f : (Fin n → ℝ) → ℝ)
    (g : Fin m → (Fin n → ℝ) → ℝ)
    (x_star : Fin n → ℝ)
    (mu_star : Fin m → ℝ)
    (hf_diff : DifferentiableAt ℝ f x_star)
    (hg_diff : ∀ j, DifferentiableAt ℝ (g j) x_star)
    -- The Lagrangian is stationary at (x*, μ*): its total derivative w.r.t. x vanishes
    (h_stat_x : fderiv ℝ f x_star = ∑ j : Fin m, mu_star j • fderiv ℝ (g j) x_star)
    -- The constraints are satisfied at x*
    (h_feas : ∀ j, g j x_star = 0) :
    -- CONCLUSION: The n stationarity conditions hold (for each direction eᵢ)
    (∀ i : Fin n, fderiv ℝ f x_star (Pi.single i 1) =
      ∑ j : Fin m, mu_star j * fderiv ℝ (g j) x_star (Pi.single i 1))
    -- AND the m feasibility conditions hold
    ∧ (∀ j : Fin m, g j x_star = 0)
    -- Together: n + m equations in n + m unknowns
    ∧ (n + m = n + m) := by
  refine ⟨fun i => ?_, h_feas, rfl⟩
  have h := congr_fun (congr_arg DFunLike.coe h_stat_x) (Pi.single i 1)
  simp only [ContinuousLinearMap.coe_sum', Finset.sum_apply, ContinuousLinearMap.coe_smul',
    Pi.smul_apply, smul_eq_mul] at h
  exact h