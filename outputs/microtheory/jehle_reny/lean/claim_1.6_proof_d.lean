import Mathlib

open BigOperators Finset
open Topology

/-- By the Envelope theorem, ∂v(p,y)/∂p_i = -λ*·x*_i, where x*_i = x_i(p,y)
    is the Marshallian demand and λ* is the Lagrange multiplier.
    The Lagrangian is L = u(x) + λ(y − p·x). Differentiating w.r.t. p_i
    gives ∂L/∂p_i = −λ·x_i, and the envelope theorem yields the result. -/
theorem Claim_1_6_proof_d
    {n : ℕ}
    (x_star : Fin n → ℝ)
    (lambda_star : ℝ)
    (i : Fin n)
    (dv_dpi : ℝ)   -- ∂v(p,y)/∂p_i
    (dL_dpi : ℝ)   -- ∂L(x*,λ*)/∂p_i
    -- Envelope theorem: ∂v/∂p_i = ∂L/∂p_i at the optimum (x*, λ*)
    (h_envelope : dv_dpi = dL_dpi)
    -- Lagrangian partial: since L = u(x*) + λ*(y − Σⱼ pⱼ·x*ⱼ),
    -- differentiating w.r.t. p_i gives ∂L/∂p_i = −λ*·x*_i
    (h_partial : dL_dpi = -lambda_star * x_star i) :
    dv_dpi = -lambda_star * x_star i := by
  linarith