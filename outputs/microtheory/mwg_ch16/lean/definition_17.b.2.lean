import Mathlib

open Finset BigOperators
open BigOperators

variable {I : Type*} [Fintype I] {L : ℕ}

/-- Individual excess demand: z_i(p) = x_i(p, p · ω_i) − ω_i -/
noncomputable def individualExcessDemand
    (x_i : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (ω_i : Fin L → ℝ)
    (p : Fin L → ℝ) : Fin L → ℝ :=
  fun l => x_i p (∑ k, p k * ω_i k) l - ω_i l

/-- Aggregate excess demand: z(p) = Σ_i z_i(p) -/
noncomputable def aggregateExcessDemand
    (x : I → (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (ω : I → Fin L → ℝ)
    (p : Fin L → ℝ) : Fin L → ℝ :=
  fun l => ∑ i, individualExcessDemand (x i) (ω i) p l