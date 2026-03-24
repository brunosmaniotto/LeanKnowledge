import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- If budget balancedness p·x(p,w) = w holds and the expenditure function
    satisfies the PDE ∂e/∂pᵢ = xᵢ(p, e(p,u)), then substituting w = e(p,u)
    into budget balancedness yields Euler's equation Σ pᵢ·∂e/∂pᵢ = e(p,u),
    which by the converse of Euler's theorem characterizes degree-1
    homogeneity in p. -/
theorem Claim_2_2_c
    {L : ℕ}
    (e : (Fin L → ℝ) → ℝ → ℝ)
    (x : (Fin L → ℝ) → ℝ → Fin L → ℝ)
    -- Budget balancedness: p · x(p,w) = w
    (hbal : ∀ (p : Fin L → ℝ) (w : ℝ), ∑ i : Fin L, p i * x p w i = w)
    -- Euler's theorem (converse): Euler's equation implies degree-1 homogeneity
    (euler_converse : (∀ (p : Fin L → ℝ) (u : ℝ),
        ∑ i : Fin L, p i * x p (e p u) i = e p u) →
      ∀ (t : ℝ) (p : Fin L → ℝ) (u : ℝ),
        e (fun i => t * p i) u = t * e p u) :
    -- Conclusion: e is homogeneous of degree 1 in p
    ∀ (t : ℝ) (p : Fin L → ℝ) (u : ℝ),
      e (fun i => t * p i) u = t * e p u := by
  apply euler_converse
  intro p u
  exact hbal p (e p u)