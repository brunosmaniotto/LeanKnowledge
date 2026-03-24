import Mathlib

open Finset BigOperators

variable {I : Type} [Fintype I] [DecidableEq I]
variable (T : I → Type)
variable (c_bar_VCG : ∀ i, T i → ℝ)
variable (next : Equiv.Perm I)
variable (U_VCG : ∀ i, T i → T i → ℝ)
variable (ex_ante_cost : I → ℝ)

-- Axioms for VCG mechanism
variable (h_VCG_incentive : ∀ i (t_i : T i), ∀ r_i, U_VCG i t_i t_i ≥ U_VCG i r_i t_i)
variable (h_VCG_IR : ∀ i (t_i : T i), U_VCG i t_i t_i ≥ 0)
variable (h_ex_ante_cost_nonneg : ∀ i, ex_ante_cost i ≥ 0)

-- New cost function for the budget-balanced expected externality mechanism
noncomputable def new_cost (t : (i : I) → T i) (i : I) : ℝ :=
  c_bar_VCG i (t i) - c_bar_VCG (next i) (t (next i))

-- New expected utility function