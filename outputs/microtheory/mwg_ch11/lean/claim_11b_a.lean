import Mathlib

open scoped Classical
open Real
open Topology

theorem Claim_11B_a (φ₁ φ₂ : ℝ → ℝ)
    (φ₁_diff : Differentiable ℝ φ₁) (φ₂_diff : Differentiable ℝ φ₂)
    (h_star h_opt : ℝ)
    (h_star_comp_eq : deriv φ₁ h_star = 0)
    (h_opt_pareto_eq : deriv φ₁ h_opt = -deriv φ₂ h_opt)
    (phi2_prime_ne_zero : ∀ h, deriv φ₂ h ≠ 0) :
    ¬ (h_star = h_opt) ∨ (h_star = 0 ∧ h_opt = 0) :=
  by
  -- Part 1: Prove that (h_star = 0 ∧ h_opt = 0) is impossible under the given conditions.
  have h_zero_case_impossible : ¬ (h_star = 0 ∧ h_opt = 0) :=
    by
    intro h_zero_assum -- Assume `h_star = 0 ∧ h_opt = 0` for contradiction
    rcases h_zero_assum with ⟨h_star_eq_zero, h_opt_eq_zero⟩

    -- Use `h_star_comp_eq` and `h_star = 0` to deduce `deriv φ₁ 0 = 0`.
    have deriv_phi1_0_eq_zero : deriv φ₁ 0 = 0 :=
      by
      rw [h_star_eq_zero] at h_star_comp_eq
      exact h_star_comp_eq

    -- Use `h_opt_pareto_eq` and `h_opt = 0` to deduce `deriv φ₁ 0 = -deriv φ₂ 0`.
    have deriv_phi1_0_eq_neg_deriv_phi2_0 : deriv φ₁ 0 = -deriv φ₂ 0 :=
      by
      rw [h_opt_eq_zero] at h_opt_pareto_eq
      exact h_opt_pareto_eq

    -- Equating the two expressions for `deriv φ₁ 0`.
    have zero_eq_neg_deriv_phi2_0 : 0 = -deriv φ₂ 0 :=
      by
      rw [deriv_phi1_0_eq_zero] at deriv_phi1_0_eq_neg_deriv_phi2_0
      exact deriv_phi1_0_eq_neg_deriv_phi2_0

    -- From `0 = -deriv φ₂ 0`, we get `deriv φ₂ 0 = 0`.
    have deriv_phi2_0_eq_zero : deriv φ₂ 0 = 0 :=
      by
      exact neg_eq_zero.mp zero_eq_neg_deriv_phi2_0.symm

    -- The hypothesis `phi2_prime_ne_zero` states `deriv φ₂ h ≠ 0` for all `h`.
    -- Applying this for `h = 0`:
    have deriv_phi2_0_ne_zero : deriv φ₂ 0 ≠ 0 := phi2_prime_ne_zero 0

    -- We have both `deriv φ₂ 0 = 0` and `deriv φ₂ 0 ≠ 0`, which is a contradiction.
    contradiction

  -- Part 2: Use the impossibility of the "unless" clause to simplify the goal.
  -- The goal is `¬ (h_star = h_opt) ∨ (h_star = 0 ∧ h_opt = 0)`.
  -- We have `h_zero_case_impossible : ¬ (h_star = 0 ∧ h_opt = 0)`.
  -- Thus, the right disjunct is false, so we must prove the left disjunct.
  apply Or.inl

  -- Part 3: Prove `¬ (h_star = h_opt)` by contradiction.
  intro h_star_eq_h_opt -- Assume `h_star = h_opt` for contradiction

  -- Substitute `h_star` for `h_opt` in the Pareto optimality condition `h_opt_pareto_eq`.
  have h_star_pareto_eq : deriv φ₁ h_star = -deriv φ₂ h_star :=
    by
    rw [← h_star_eq_h_opt] at h_opt_pareto_eq
    exact h_opt_pareto_eq

  -- We have `deriv φ₁ h_star = 0` (from `h_star_comp_eq`).
  -- And `deriv φ₁ h_star = -deriv φ₂ h_star` (from `h_star_pareto_eq`).
  -- Equating these two gives `0 = -deriv φ₂ h_star`.
  have zero_eq_neg_deriv_phi2_h_star : 0 = -deriv φ₂ h_star :=
    by
    rw [h_star_comp_eq] at h_star_pareto_eq
    exact h_star_pareto_eq

  -- From `0 = -deriv φ₂ h_star`, it implies `deriv φ₂ h_star = 0`.
  have deriv_phi2_h_star_eq_zero : deriv φ₂ h_star = 0 :=
    by
    exact neg_eq_zero.mp zero_eq_neg_deriv_phi2_h_star.symm

  -- The hypothesis `phi2_prime_ne_zero` states `deriv φ₂ h ≠ 0` for all `h`.
  -- Applying this to `h_star`:
  have deriv_phi2_h_star_ne_zero := phi2_prime_ne_zero h_star

  -- We have `deriv φ₂ h_star = 0` and `deriv φ₂ h_star ≠ 0`, which is a contradiction.
  contradiction