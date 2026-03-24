import Mathlib
open Topology
open BigOperators

/-- An alternative in the quasilinear environment: a project choice k ∈ K
    and transfers t_i to each agent, with Σ t_i ≤ 0. -/
structure QuasilinearAlternative (K : Type*) [Fintype K] (I : ℕ) where
  /-- The project choice -/
  project : K
  /-- Transfer to each agent -/
  transfers : Fin I → ℝ
  /-- Budget balance: total transfers are non-positive -/
  budget_balance : ∑ i, transfers i ≤ 0

/-- Agent i's utility in the quasilinear environment:
    u_i(x, θ_i) = v_i(k, θ_i) + (m_i + t_i) -/
noncomputable def quasilinearUtility {K : Type*} [Fintype K] {I : ℕ}
    (v : Fin I → K → ℝ → ℝ)  -- v_i(k, θ_i): valuation function
    (m : Fin I → ℝ)           -- m_i: initial endowment of money
    (x : QuasilinearAlternative K I)
    (i : Fin I)
    (θ_i : ℝ) : ℝ :=
  v i x.project θ_i + (m i + x.transfers i)