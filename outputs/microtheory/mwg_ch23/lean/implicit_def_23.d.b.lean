import Mathlib

open MeasureTheory
open Topology

/-- Parameters for the linear-in-type utility setting (MWG 23.D). -/
structure LinearTypeSettings (n : ℕ) where
  /-- Type space bounds for each agent -/
  θ_L : Fin n → ℝ
  θ_H : Fin n → ℝ
  hθ : ∀ i, θ_L i < θ_H i
  /-- Density of agent i's type distribution, φ_i(θ_i) > 0 on [θ_L_i, θ_H_i] -/
  φ : Fin n → ℝ → ℝ
  hφ_pos : ∀ i θ, θ ∈ Set.Icc (θ_L i) (θ_H i) → φ i θ > 0
  /-- Distribution (CDF) of agent i's type -/
  Φ : Fin n → ℝ → ℝ
  /-- Measure on each agent's type space induced by φ_i -/
  μ : Fin n → Measure ℝ
  /-- Initial endowment of money for each agent -/
  m : Fin n → ℝ
  /-- Project choice as a function of the full type profile -/
  k : (Fin n → ℝ) → ℝ
  /-- Transfer to agent i as a function of the full type profile -/
  t : Fin n → (Fin n → ℝ) → ℝ
  /-- Valuation of project choice for agent i -/
  v : Fin n → ℝ → ℝ

variable {n : ℕ}

/-- Bernoulli utility: u_i(x, θ_i) = θ_i · v_i(k) + (m_i + t_i) -/
noncomputable def bernoulliUtility (S : LinearTypeSettings n) (i : Fin n)
    (θ_i : ℝ) (kVal : ℝ) (t_i : ℝ) : ℝ :=
  θ_i * S.v i kVal + (S.m i + t_i)

/-- Product measure over all agents except i -/
noncomputable def othersMeasure (S : LinearTypeSettings n) (i : Fin n) :
    Measure (Fin n → ℝ) :=
  Measure.pi (fun j => S.μ j)

/-- Expected transfer: t̄_i(θ_i) = E_{θ_{-i}}[t_i(θ_i, θ_{-i})] -/
noncomputable def expectedTransfer (S : LinearTypeSettings n) (i : Fin n)
    (θ_i : ℝ) : ℝ :=
  ∫ θ, S.t i (Function.update θ i θ_i) ∂(othersMeasure S i)

/-- Expected project valuation: v̄_i(θ_i) = E_{θ_{-i}}[v_i(k(θ_i, θ_{-i}))] -/
noncomputable def expectedValuation (S : LinearTypeSettings n) (i : Fin n)
    (θ_i : ℝ) : ℝ :=
  ∫ θ, S.v i (S.k (Function.update θ i θ_i)) ∂(othersMeasure S i)

/-- Interim expected utility: U_i(θ_i) = θ_i · v̄_i(θ_i) + t̄_i(θ_i) -/
noncomputable def interimUtility (S : LinearTypeSettings n) (i : Fin n)
    (θ_i : ℝ) : ℝ :=
  θ_i * expectedValuation S i θ_i + expectedTransfer S i θ_i