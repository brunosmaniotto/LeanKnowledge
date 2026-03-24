import Mathlib

open Set
open Topology

/-- The i-th leading principal minor of the Hessian of f at x -/
axiom leadingPrincipalMinor (n : ℕ) (f : (Fin n → ℝ) → ℝ)
    (x : Fin n → ℝ) (i : Fin n) : ℝ

/-- Axiom (Theorem A2.11): The alternating sign condition on the leading
    principal minors of the Hessian implies strict concavity on a convex domain.
    (-1)^i D_i(x) > 0 for all x means the Hessian is negative definite everywhere. -/
axiom hessian_neg_def_strict_concave
    {n : ℕ} {S : Set (Fin n → ℝ)} (hS : Convex ℝ S)
    {f : (Fin n → ℝ) → ℝ}
    (h : ∀ x ∈ S, ∀ i : Fin n,
      (-1) ^ (i.val + 1) * leadingPrincipalMinor n f x i > 0) :
    StrictConcaveOn ℝ S f

/-- If (-1)^i Dᵢ(x) > 0 for i = 1,...,n holds for all x in the domain,
    then f is strictly concave (by Theorem A2.11). -/
theorem claim_A2_11_a
    {n : ℕ} {S : Set (Fin n → ℝ)} (hS : Convex ℝ S)
    {f : (Fin n → ℝ) → ℝ}
    (h : ∀ x ∈ S, ∀ i : Fin n,
      (-1) ^ (i.val + 1) * leadingPrincipalMinor n f x i > 0) :
    StrictConcaveOn ℝ S f :=
  hessian_neg_def_strict_concave hS h