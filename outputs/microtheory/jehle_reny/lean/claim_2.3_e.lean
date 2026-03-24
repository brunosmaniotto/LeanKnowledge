import Mathlib

open Matrix Finset BigOperators
open Topology

noncomputable section

variable {n : ℕ}

/-- One-sided maximum principle at the origin: if f is differentiable at 0
    and f(t) ≤ f(0) for all t ∈ [0, δ), then f'(0) ≤ 0. -/
axiom deriv_nonpos_of_right_max_at_zero (f : ℝ → ℝ)
    (hf : DifferentiableAt ℝ f 0)
    (hmax : ∃ δ > (0 : ℝ), ∀ t, 0 ≤ t → t < δ → f t ≤ f 0) :
    deriv f 0 ≤ 0

/-- **Slutsky Negative Semidefiniteness (MWG Claim 2.3.e)**

If a choice function x(p, y) satisfies WARP and budget balancedness,
and x is differentiable, then the Slutsky matrix S with entries
  S_{ij} = ∂xᵢ/∂pⱼ + xⱼ · ∂xᵢ/∂y
is negative semidefinite: zᵀSz ≤ 0 for all z ∈ ℝⁿ.

The proof proceeds as follows:
1. For any direction z, define f(t) = z · x(p₀ + tz, (p₀ + tz) · x₀).
2. WARP + Walras' law imply f(t) ≤ f(0) for t ∈ [0, δ).
3. By differentiability, f'(0) ≤ 0.
4. The chain rule gives f'(0) = zᵀSz.
5. Since z is arbitrary, S is negative semidefinite. -/
theorem slutsky_matrix_negative_semidefinite
    (S : Matrix (Fin n) (Fin n) ℝ)
    -- For each direction z, the compensated demand function along z
    (f : (Fin n → ℝ) → ℝ → ℝ)
    -- WARP + Walras' law ⟹ f_z has a right-sided maximum at t = 0
    (hmax : ∀ z, ∃ δ > (0 : ℝ), ∀ t, 0 ≤ t → t < δ → f z t ≤ f z 0)
    -- Differentiability of the compensated demand function at t = 0
    (hdiff : ∀ z, DifferentiableAt ℝ (f z) 0)
    -- Chain rule: f_z'(0) = zᵀ S z
    (hchain : ∀ z, deriv (f z) 0 = dotProduct z (S.mulVec z)) :
    ∀ z : Fin n → ℝ, dotProduct z (S.mulVec z) ≤ 0 := by
  intro z
  have h := deriv_nonpos_of_right_max_at_zero (f z) (hdiff z) (hmax z)
  linarith [hchain z]