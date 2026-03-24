import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable section

theorem pure_deviation_suffices_for_nash
    (I : Type) [Fintype I] [DecidableEq I]
    (S : I → Type) [(i : I) → Fintype (S i)] [(i : I) → DecidableEq (S i)] [(i : I) → Nonempty (S i)]
    (u : (i : I) → ((j : I) → S j) → ℝ)
    (σ : (i : I) → S i → ℝ)
    (σ_nonneg : ∀ i s, 0 ≤ σ i s)
    (σ_sum : ∀ i, ∑ s : S i, σ i s = 1)
    (expected_payoff : (i : I) → ((j : I) → S j → ℝ) → ℝ)
    (linearity : ∀ i (τ : S i → ℝ), (∀ s, 0 ≤ τ s) → ∑ s : S i, τ s = 1 →
      expected_payoff i (Function.update σ i τ) = ∑ s : S i, τ s • expected_payoff i (Function.update σ i (fun s' => if s' = s then 1 else 0)))
    (no_pure_improvement : ∀ i (s : S i),
      expected_payoff i (Function.update σ i (fun s' => if s' = s then 1 else 0)) ≤ expected_payoff i σ) :
    ∀ i (τ : S i → ℝ), (∀ s, 0 ≤ τ s) → ∑ s : S i, τ s = 1 →
      expected_payoff i (Function.update σ i τ) ≤ expected_payoff i σ := by
  intro i τ hτ_nonneg hτ_sum
  rw [linearity i τ hτ_nonneg hτ_sum]
  calc ∑ s : S i, τ s • expected_payoff i (Function.update σ i (fun s' => if s' = s then 1 else 0))
      ≤ ∑ s : S i, τ s • expected_payoff i σ := by
        apply Finset.sum_le_sum
        intro s _
        exact mul_le_mul_of_nonneg_left (no_pure_improvement i s) (hτ_nonneg s)
    _ = (∑ s : S i, τ s) • expected_payoff i σ := by
        rw [Finset.sum_smul]
    _ = expected_payoff i σ := by
        rw [hτ_sum, one_smul]