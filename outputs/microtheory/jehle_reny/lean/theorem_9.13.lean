import Mathlib
open Finset
open BigOperators

set_option linter.unusedVariables false

variable (N : ℕ) (hN : 0 < N)
variable (T : Fin N → Type) [∀ i, Fintype (T i)]
variable (X : Type)
variable (q : (∀ i, T i) → ℝ)
variable (c_bar_VCG : ∀ i, T i → ℝ)
variable (ψ_star : Fin N → ℝ)
variable (c_bar_VCG_total : Fin N → ℝ)
variable (x_hat : (∀ i, T i) → X)
variable (c_VCG_ex_post : (∀ i, T i) → Fin N → ℝ)

variable (IncentiveCompatible : ((∀ i, T i) → X) → (Fin N → (∀ i, T i) → ℝ) → Prop)
variable (ExPostEfficient : ((∀ i, T i) → X) → (Fin N → (∀ i, T i) → ℝ) → Prop)
variable (BudgetBalanced : (Fin N → (∀ i, T i) → ℝ) → Prop)
variable (IndividuallyRational : (Fin N → (∀ i, T i) → ℝ) → Prop)

axiom expected_surplus : ∑ t : ∀ i, T i, q t * ∑ i : Fin N, (c_VCG_ex_post t i - ψ_star i) ≥ 0

axiom IR_VCG_IC : IncentiveCompatible x_hat (fun i t => c_VCG_ex_post t i - ψ_star i)
axiom IR_VCG_ExPost : ExPostEfficient x_hat (fun i t => c_VCG_ex_post t i - ψ_star i)
axiom IR_VCG_IR : IndividuallyRational (fun i t => c_VCG_ex_post t i - ψ_star i)

axiom Theorem_9_12 (next : Fin N → Fin N) (x : (∀ i, T i) → X) (c : Fin N → (∀ i, T i) → ℝ)
    (h_surplus : ∑ t, q t * ∑ i, c i t ≥ 0)
    (h_IC : IncentiveCompatible x c)
    (h_ExPost : ExPostEfficient x c)
    (h_IR : IndividuallyRational c) :
    ∃ (c' : Fin N → (∀ i, T i) → ℝ),
      IncentiveCompatible x c' ∧ ExPostEfficient x c' ∧ BudgetBalanced c' ∧ IndividuallyRational c' ∧
      ∀ i t, c' i t = c_bar_VCG i (t i) - ψ_star i
        - (c_bar_VCG (next i) (t (next i)) - c_bar_VCG_total (next i))
        - (1 / (N : ℝ)) * ∑ j : Fin N, (c_bar_VCG_total j - ψ_star j)

noncomputable def next : Fin N → Fin N :=
  fun i => ⟨(i.val + 1) % N, by
    exact Nat.mod_lt (i.val + 1) hN⟩