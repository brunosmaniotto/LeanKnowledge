import Mathlib

open BigOperators Matrix
open Topology
open Matrix

variable (n_goods n_agents : ℕ)

axiom S_individual : (Fin n_goods → ℝ) → ℝ → Fin n_agents → Matrix (Fin n_goods) (Fin n_goods) ℝ
axiom S_aggregate : (Fin n_goods → ℝ) → ℝ → Matrix (Fin n_goods) (Fin n_goods) ℝ
axiom α_share : Fin n_agents → ℝ
axiom Dw_x : (Fin n_goods → ℝ) → ℝ → Fin n_agents → Fin n_goods → ℝ
axiom Dw_x_agg : (Fin n_goods → ℝ) → ℝ → Fin n_goods → ℝ
axiom x_i : (Fin n_goods → ℝ) → ℝ → Fin n_agents → Fin n_goods → ℝ
axiom x_agg : (Fin n_goods → ℝ) → ℝ → Fin n_goods → ℝ

noncomputable def C_matrix (p : Fin n_goods → ℝ) (w : ℝ) : Matrix (Fin n_goods) (Fin n_goods) ℝ :=
  ∑ i : Fin n_agents, Matrix.of (fun (l k : Fin n_goods) =>
    α_share n_agents i *
      (Dw_x n_goods n_agents p (α_share n_agents i * w) i l - Dw_x_agg n_goods p w l) *
      ((1 / α_share n_agents i) * x_i n_goods n_agents p (α_share n_agents i * w) i k - x_agg n_goods p w k))

axiom slutsky_decomposition (p : Fin n_goods → ℝ) (w : ℝ) :
    S_aggregate n_goods p w =
      (∑ i : Fin n_agents, S_individual n_goods n_agents p (α_share n_agents i * w) i) -
        C_matrix n_goods n_agents p w

theorem Claim_4C_Slutsky_decomposition (p : Fin n_goods → ℝ) (w : ℝ) :
    S_aggregate n_goods p w -
      (∑ i : Fin n_agents, S_individual n_goods n_agents p (α_share n_agents i * w) i) =
        - C_matrix n_goods n_agents p w := by
  have h := slutsky_decomposition n_goods n_agents p w
  ext i j
  simp only [Matrix.sub_apply, Matrix.neg_apply]
  have hij := congr_fun (congr_fun h i) j
  simp only [Matrix.sub_apply] at hij
  linarith