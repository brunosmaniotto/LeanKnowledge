import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Jensen's Inequality: for a concave function f and weights summing to 1,
    ∑ wᵢ • f(xᵢ) ≤ f(∑ wᵢ • xᵢ). -/
theorem jensens_inequality_concave
    {n : ℕ} (f : ℝ → ℝ) (w : Fin n → ℝ) (x : Fin n → ℝ)
    (hf : ConcaveOn ℝ Set.univ f)
    (hw_nonneg : ∀ i, 0 ≤ w i)
    (hw_sum : ∑ i, w i = 1) :
    ∑ i, w i • f (x i) ≤ f (∑ i, w i • x i) :=
  hf.le_map_sum (fun i _ => hw_nonneg i) (by simpa using hw_sum) (fun i _ => Set.mem_univ _)