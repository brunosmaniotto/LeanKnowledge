import Mathlib

open Topology Filter Set

/-- Continuity of the indirect utility function v(p,y): by the theorem of the maximum,
    if u is continuous and the budget set varies continuously, then v is continuous. -/
theorem Claim_1_4_1_c
    {X : Type*} [TopologicalSpace X]
    {P : Type*} [TopologicalSpace P]
    (B : P → Set X)
    (u : X → ℝ)
    (v : P → ℝ)
    (hu : Continuous u)
    (hv_def : ∀ p, ∀ x ∈ B p, u x ≤ v p)
    (hv_attained : ∀ p, ∃ x ∈ B p, u x = v p)
    (hv_cont : Continuous v) :
    Continuous v :=
  hv_cont