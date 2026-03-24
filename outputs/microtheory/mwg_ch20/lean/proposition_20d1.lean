import Mathlib

open Filter Topology BigOperators Finset
open BigOperators
open Finset

structure WalrasianEquilibrium where
  y_a : ℕ → ℝ
  y_b : ℕ → ℝ
  p : ℕ → ℝ
  ω : ℕ → ℝ
  π : ℕ → ℝ
  accounting_identity : ∀ T : ℕ,
    (∑ t ∈ Finset.range T, (π t + p t * ω t)) -
    (∑ t ∈ Finset.range T, (p t * (y_a (t - 1) + y_b t + ω t))) =
    p (T + 1) * y_a T
  profit_sum_converges : ∃ w₁ : ℝ,
    Tendsto (fun T => ∑ t ∈ Finset.range T, (π t + p t * ω t)) atTop (nhds w₁)
  consumption_sum_converges : ∃ w₂ : ℝ,
    Tendsto (fun T => ∑ t ∈ Finset.range T, (p t * (y_a (t - 1) + y_b t + ω t))) atTop (nhds w₂)
  /-- In Walrasian equilibrium, total wealth equals total expenditure -/
  wealth_equals_expenditure : ∀ w₁ w₂ : ℝ,
    Tendsto (fun T => ∑ t ∈ Finset.range T, (π t + p t * ω t)) atTop (nhds w₁) →
    Tendsto (fun T => ∑ t ∈ Finset.range T, (p t * (y_a (t - 1) + y_b t + ω t))) atTop (nhds w₂) →
    w₁ = w₂

theorem Proposition_20D1 (E : WalrasianEquilibrium) :
    Tendsto (fun T => E.p (T + 1) * E.y_a T) atTop (nhds 0) := by
  obtain ⟨w₁, hw₁⟩ := E.profit_sum_converges
  obtain ⟨w₂, hw₂⟩ := E.consumption_sum_converges
  have h_eq : (fun T => E.p (T + 1) * E.y_a T) =
      (fun T => (∑ t ∈ Finset.range T, (E.π t + E.p t * E.ω t)) -
                (∑ t ∈ Finset.range T, (E.p t * (E.y_a (t - 1) + E.y_b t + E.ω t)))) := by
    ext T
    exact (E.accounting_identity T).symm
  rw [h_eq]
  have h_diff : w₁ - w₂ = 0 := by
    have := E.wealth_equals_expenditure w₁ w₂ hw₁ hw₂
    linarith
  rw [← h_diff]
  exact Tendsto.sub hw₁ hw₂