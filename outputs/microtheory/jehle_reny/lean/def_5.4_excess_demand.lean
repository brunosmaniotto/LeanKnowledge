import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The aggregate excess demand function (Definition 5.4).
    Given individual demand functions xᵢ(p, w) and endowments eᵢ,
    z_k(p) = Σᵢ xᵢ_k(p, p · eᵢ) − Σᵢ eᵢ_k. -/
noncomputable def aggregateExcessDemand
    {I : Type*} [Fintype I] {n : ℕ}
    (x : I → (Fin n → ℝ) → ℝ → (Fin n → ℝ))
    (e : I → (Fin n → ℝ))
    (p : Fin n → ℝ) : Fin n → ℝ :=
  fun k => ∑ i : I, x i p (∑ j : Fin n, p j * e i j) k - ∑ i : I, e i k