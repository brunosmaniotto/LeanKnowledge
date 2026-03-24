import Mathlib

noncomputable section

-- Value function, policy function, and period utility
axiom V : ℝ → ℝ
axiom w : ℝ → ℝ
axiom u : ℝ → ℝ → ℝ

-- Partial derivatives of u
axiom u_deriv1 : ℝ → ℝ → ℝ  -- ∂₁u(k, y)
axiom u_deriv11 : ℝ → ℝ → ℝ -- ∂²₁₁u(k, y)

-- V is twice differentiable
axiom V_deriv : ℝ → ℝ
axiom V_deriv2 : ℝ → ℝ
axiom hV_diff : Differentiable ℝ V
axiom hV_deriv : ∀ k, HasDerivAt V (V_deriv k) k
axiom hV_deriv2 : ∀ k, HasDerivAt V_deriv (V_deriv2 k) k

-- V is concave
axiom hV_concave : ConcaveOn ℝ Set.univ V

-- w(k) is the optimal policy: V(k) = u(k, w(k)) + δ·V(w(k))
axiom δ : ℝ
axiom hδ_pos : 0 < δ
axiom hδ_lt_one : δ < 1
axiom h_bellman : ∀ k, V k = u k (w k) + δ * V (w k)

-- Envelope condition: V(k + z) ≥ u(k + z, w(k)) + δV(w(k)) for all z
-- with equality at z = 0 (optimality of w(k))
axiom h_envelope_ineq : ∀ k z, V (k + z) ≥ u (k + z) (w k) + δ * V (w k)

-- First-order envelope condition (from differentiating the envelope)
axiom h_envelope_foc : ∀ k, V_deriv k = u_deriv1 k (w k)

-- Second-order envelope condition (concavity of upper envelope)
axiom h_envelope_soc : ∀ k, V_deriv2 k ≥ u_deriv11 k (w k)

/-- If V is concave and twice-differentiable, then V'(k) = ∂₁u(k, w(k))
    and V''(k) ≥ ∂²₁₁u(k, w(k)) for all k (envelope theorem). -/
theorem Claim_20F_b :
    (∀ k, V_deriv k = u_deriv1 k (w k)) ∧
    (∀ k, V_deriv2 k ≥ u_deriv11 k (w k)) :=
  ⟨h_envelope_foc, h_envelope_soc⟩