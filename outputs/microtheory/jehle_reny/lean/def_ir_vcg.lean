import Mathlib

open BigOperators
open Topology

/-- The Individually Rational VCG (IR-VCG) mechanism.
    Augments the standard VCG mechanism with minimum participation subsidies ψ*_i
    so that each agent's total cost is c^VCG_i(t) - ψ*_i. -/
structure IRVCGMechanism (I : ℕ) (Θ : Fin I → Type*) (X : Type*) where
  /-- The ex post efficient allocation rule x̂(t) -/
  xHat : (∀ i, Θ i) → X
  /-- VCG cost for agent i given report profile t -/
  vcgCost : Fin I → (∀ i, Θ i) → ℝ
  /-- Minimum participation subsidy ψ*_i for agent i (independent of reports) -/
  subsidy : Fin I → ℝ

/-- Total cost to agent i under the IR-VCG mechanism: c^VCG_i(t) - ψ*_i. -/
noncomputable def IRVCGMechanism.totalCost {I : ℕ} {Θ : Fin I → Type*} {X : Type*}
    (m : IRVCGMechanism I Θ X) (i : Fin I) (t : ∀ i, Θ i) : ℝ :=
  m.vcgCost i t - m.subsidy i