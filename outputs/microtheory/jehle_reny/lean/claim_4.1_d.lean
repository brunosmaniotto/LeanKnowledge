import Mathlib

open BigOperators Finset
open Topology

/-- Claim 4.1.d: Homogeneity of degree zero is the only restriction from
    utility maximization preserved under aggregation to market demand
    for a single good (Sonnenschein 1973).

    We prove the constructive direction: if each individual's demand for
    a single good is homogeneous of degree zero, so is market demand. -/
theorem Claim_4_1_d
    {I : Type*} [Fintype I]
    (x : I → ℝ → ℝ → ℝ)  -- individual demand: agent → price → wealth → quantity
    (hom : ∀ i, ∀ p w α : ℝ, α > 0 → x i (α * p) (α * w) = x i p w)
    : ∀ p w α : ℝ, α > 0 →
      (∑ i : I, x i (α * p) (α * w)) = ∑ i : I, x i p w := by
  intro p w α hα
  exact Finset.sum_congr rfl (fun i _ => hom i p w α hα)