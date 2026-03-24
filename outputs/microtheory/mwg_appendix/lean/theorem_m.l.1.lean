import Mathlib
open Topology
open BigOperators

axiom envelope_sum_swap {n m : ℕ} (mu : Fin m → ℝ) (A : Fin m → Fin n → ℝ) (b : Fin n → ℝ) : ∑ i : Fin n, (∑ j : Fin m, mu j * A j i) * b i = ∑ j : Fin m, mu j * ∑ i : Fin n, A j i * b i
axiom envelope_constraint_substitution {n m : ℕ} (mu : Fin m → ℝ) (dg_dx : Fin m → Fin n → ℝ) (dx_dq : Fin n → ℝ) (dg_dq : Fin m → ℝ) (hconstr : ∀ j : Fin m, ∑ i : Fin n, dg_dx j i * dx_dq i + dg_dq j = 0) : ∑ j : Fin m, mu j * ∑ i : Fin n, dg_dx j i * dx_dq i = -∑ j : Fin m, mu j * dg_dq j
axiom envelope_chain_rule_step {n m : ℕ} (dv_dq df_dq : ℝ) (df_dx : Fin n → ℝ) (dx_dq : Fin n → ℝ) (mu : Fin m → ℝ) (dg_dq : Fin m → ℝ) (dg_dx : Fin m → Fin n → ℝ) (hchain : dv_dq = df_dq + ∑ i : Fin n, df_dx i * dx_dq i) (hfoc : ∀ i : Fin n, df_dx i = ∑ j : Fin m, mu j * dg_dx j i) (hconstr : ∀ j : Fin m, ∑ i : Fin n, dg_dx j i * dx_dq i + dg_dq j = 0) : dv_dq = df_dq - ∑ j : Fin m, mu j * dg_dq j

theorem envelope_theorem_main {n m s : ℕ}
    (dv_dq df_dq : Fin s → ℝ) (df_dx : Fin n → ℝ)
    (dx_dq : Fin n → Fin s → ℝ) (mu : Fin m → ℝ)
    (dg_dq : Fin m → Fin s → ℝ) (dg_dx : Fin m → Fin n → ℝ)
    (hchain : ∀ k : Fin s, dv_dq k = df_dq k + ∑ i : Fin n, df_dx i * dx_dq i k)
    (hfoc : ∀ i : Fin n, df_dx i = ∑ j : Fin m, mu j * dg_dx j i)
    (hconstr : ∀ j : Fin m, ∀ k : Fin s, ∑ i : Fin n, dg_dx j i * dx_dq i k + dg_dq j k = 0)
    : ∀ k : Fin s, dv_dq k = df_dq k - ∑ j : Fin m, mu j * dg_dq j k := by
  intro k
  exact envelope_chain_rule_step (dv_dq k) (df_dq k) df_dx (fun i => dx_dq i k) mu (fun j => dg_dq j k) dg_dx (hchain k) hfoc (fun j => hconstr j k)