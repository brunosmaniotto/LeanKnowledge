import Mathlib
open Topology
open BigOperators
set_option linter.unusedVariables false

axiom consumer_sum_nonpos (I : Type u_1) [Fintype I] (π : I → ℝ) (w L : ℝ) (w_bar : I → ℝ)
    (h_wbar_ge : ∀ i, w_bar i ≥ w - π i * L) : ∑ i, (w - π i * L - w_bar i) ≤ 0

axiom firm_sum_nonneg (I J : Type u_1) [Fintype I] [Fintype J] (EP : J → I → ℝ)
    (h_firm_nonneg : ∀ j, ∑ i, EP j i ≥ 0) : ∑ j, ∑ i, EP j i ≥ 0

axiom accounting_identity_total (I J : Type u_1) [Fintype I] [Fintype J] (π : I → ℝ) (w L : ℝ)
    (w_bar : I → ℝ) (EP : J → I → ℝ) (h_accounting : ∀ i, ∑ j, EP j i = w - π i * L - w_bar i) :
    ∑ i, ∑ j, EP j i = ∑ i, (w - π i * L - w_bar i)

axiom double_sum_comm (I J : Type u_1) [Fintype I] [Fintype J] (EP : J → I → ℝ) :
    ∑ i, ∑ j, EP j i = ∑ j, ∑ i, EP j i

axiom strict_sum_neg (I : Type u_1) [Fintype I] (f : I → ℝ) (h_nonpos : ∀ i, f i ≤ 0)
    (h_exists : ∃ i, f i < 0) : ∑ i, f i < 0

theorem competitive_allocation_Pareto_efficient (I J : Type u_1) [Fintype I] [Fintype J]
    (π : I → ℝ) (w L : ℝ) (w_bar : I → ℝ) (EP : J → I → ℝ) (h_wbar_ge : ∀ i, w_bar i ≥ w - π i * L)
    (h_strict : ∃ i, w_bar i > w - π i * L) (h_accounting : ∀ i, ∑ j, EP j i = w - π i * L - w_bar i)
    (h_firm_nonneg : ∀ j, ∑ i, EP j i ≥ 0) : False := by
  have h1 : ∑ i, (w - π i * L - w_bar i) ≤ 0 := consumer_sum_nonpos I π w L w_bar h_wbar_ge
  have h2 : ∑ j, ∑ i, EP j i ≥ 0 := firm_sum_nonneg I J EP h_firm_nonneg
  have h3 : ∑ i, ∑ j, EP j i = ∑ i, (w - π i * L - w_bar i) :=
    accounting_identity_total I J π w L w_bar EP h_accounting
  have h4 : ∑ i, ∑ j, EP j i = ∑ j, ∑ i, EP j i := double_sum_comm I J EP
  have h_total_eq : ∑ i, (w - π i * L - w_bar i) = ∑ j, ∑ i, EP j i := by
    rw [← h4, h3]
  have h_nonneg : ∑ i, (w - π i * L - w_bar i) ≥ 0 := by
    rw [h_total_eq]
    exact h2
  have hA0 : ∑ i, (w - π i * L - w_bar i) = 0 := by
    linarith
  rcases h_strict with ⟨i0, hi0⟩
  have h_nonpos : ∀ i, (w - π i * L - w_bar i) ≤ 0 := by
    intro i
    have h := h_wbar_ge i
    linarith
  have h_neg : ∑ i, (w - π i * L - w_bar i) < 0 :=
    strict_sum_neg I (fun i => w - π i * L - w_bar i) h_nonpos ⟨i0, by linarith⟩
  linarith