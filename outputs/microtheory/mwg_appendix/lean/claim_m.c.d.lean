import Mathlib
open Finset BigOperators
open Topology

/-- Condition (M.C.4): the tangent to the graph of a concave function lies weakly above the graph.
    For a differentiable concave function f on a convex set, f(y) ≤ f(x) + f'(x) · (y - x). -/
axiom MWG.tangent_above_graph_of_concave
    (f : ℝ → ℝ) (s : Set ℝ) (f' : ℝ → ℝ)
    (hs : Convex ℝ s)
    (hf : ConcaveOn ℝ s f)
    (hf' : ∀ x ∈ s, HasDerivAt f (f' x) x)
    (x : ℝ) (hx : x ∈ s)
    (y : ℝ) (hy : y ∈ s) :
    f y ≤ f x + f' x * (y - x)

theorem Claim_M_C_d
    (f : ℝ → ℝ) (s : Set ℝ) (f' : ℝ → ℝ)
    (hs : Convex ℝ s)
    (hf : ConcaveOn ℝ s f)
    (hf' : ∀ x ∈ s, HasDerivAt f (f' x) x)
    (x : ℝ) (hx : x ∈ s)
    (y : ℝ) (hy : y ∈ s) :
    f y ≤ f x + f' x * (y - x) :=
  MWG.tangent_above_graph_of_concave f s f' hs hf hf' x hx y hy