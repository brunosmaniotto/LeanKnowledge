import Mathlib

open Finset BigOperators
open Filter
open Topology
open BigOperators

/-- The social utility function extended to nonnegative mass vectors.
    Given utility functions, endowments, and a mass vector μ ∈ ℝ^H₊,
    v(μ) = max Σ_h μ_h · u_h(x_h) subject to feasibility constraints. -/
noncomputable def socialUtilityContinuum
    (H : ℕ) (L : ℕ)
    (u : Fin H → (Fin L → ℝ) → ℝ)
    (ω : Fin H → Fin L → ℝ)
    (μ : Fin H → ℝ) : ℝ :=
  sSup { val : ℝ |
    ∃ x : Fin H → Fin L → ℝ,
      val = ∑ h : Fin H, μ h * u h (x h) ∧
      (∀ ℓ : Fin L, ∑ h : Fin H, μ h * x h ℓ ≤ ∑ h : Fin H, μ h * ω h ℓ) ∧
      (∀ h : Fin H, ∀ ℓ : Fin L, x h ℓ ≥ 0) }

/-- A sequence of finite economies converges to a continuum limit μ
    if total population tends to infinity and the fraction of each type h
    converges to μ_h. -/
def IsContinuumLimit
    (H : ℕ)
    (I : ℕ → ℕ)
    (typeCount : ℕ → Fin H → ℕ)
    (μ : Fin H → ℝ) : Prop :=
  Filter.Tendsto (fun n => (I n : ℝ)) Filter.atTop Filter.atTop ∧
  ∀ h : Fin H, Filter.Tendsto (fun n => (typeCount n h : ℝ) / (I n : ℝ)) Filter.atTop (nhds (μ h))