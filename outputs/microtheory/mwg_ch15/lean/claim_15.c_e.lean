import Mathlib
open Topology

theorem pareto_optimal_consumption_unique
    {n : ℕ}
    (X : Set (Fin n → ℝ))
    (Y : Set (Fin n → ℝ))
    (ω : Fin n → ℝ)
    (u : (Fin n → ℝ) → ℝ)
    (hX_convex : Convex ℝ X)
    (hY_convex : Convex ℝ Y)
    (u_strict_quasiconcave : ∀ x y : Fin n → ℝ, x ∈ X → y ∈ X →
      x ≠ y → u x = u y →
      u (fun i => (1/2 : ℝ) * x i + (1/2 : ℝ) * y i) > u x)
    (feasible : Set (Fin n → ℝ))
    (hfeas_sub : feasible ⊆ X)
    (hfeas_convex : Convex ℝ feasible)
    (x₁ x₂ : Fin n → ℝ)
    (hx₁_feas : x₁ ∈ feasible)
    (hx₂_feas : x₂ ∈ feasible)
    (hopt₁ : ∀ z ∈ feasible, u z ≤ u x₁)
    (hopt₂ : ∀ z ∈ feasible, u z ≤ u x₂) :
    x₁ = x₂ := by
  by_contra h
  have heq : u x₁ = u x₂ := le_antisymm (hopt₂ x₁ hx₁_feas) (hopt₁ x₂ hx₂_feas)
  have hx₁X : x₁ ∈ X := hfeas_sub hx₁_feas
  have hx₂X : x₂ ∈ X := hfeas_sub hx₂_feas
  set m := fun i => (1/2 : ℝ) * x₁ i + (1/2 : ℝ) * x₂ i
  have hm_better : u m > u x₁ := u_strict_quasiconcave x₁ x₂ hx₁X hx₂X h heq
  have hm_feas : m ∈ feasible := by
    have : m = (1/2 : ℝ) • x₁ + (1/2 : ℝ) • x₂ := by
      ext i; simp [m, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
    rw [this]
    exact hfeas_convex hx₁_feas hx₂_feas (by norm_num : (0:ℝ) ≤ 1/2)
      (by norm_num : (0:ℝ) ≤ 1/2) (by norm_num : (1:ℝ)/2 + 1/2 = 1)
  linarith [hopt₁ m hm_feas]