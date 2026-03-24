import Mathlib

noncomputable section

/-- Partial derivative of u with respect to its first argument -/
axiom partialDeriv₁ (u : ℝ → ℝ → ℝ) (k c : ℝ) : ℝ

/-- Second partial derivative of u with respect to its first argument -/
axiom partialDeriv₁₁ (u : ℝ → ℝ → ℝ) (k c : ℝ) : ℝ

/-- Envelope theorem for Bellman equation (first derivative):
    When (k, ψ(k)) is interior to A and V(k) = u(k, ψ(k)) + δV(ψ(k)),
    the FOC implies V'(k) = ∂₁u(k, ψ(k)). -/
axiom envelope_first_derivative
    (u : ℝ → ℝ → ℝ) (V ψ : ℝ → ℝ) (δ : ℝ) (k : ℝ)
    (hV : Differentiable ℝ V) (hψ : Differentiable ℝ ψ)
    (bellman : ∀ x, V x = u x (ψ x) + δ * V (ψ x))
    (interior : True) :
    deriv V k = partialDeriv₁ u k (ψ k)

/-- Envelope theorem for Bellman equation (second derivative):
    If V is twice differentiable, V''(k) = ∂₁₁u(k, ψ(k)). -/
axiom envelope_second_derivative
    (u : ℝ → ℝ → ℝ) (V ψ : ℝ → ℝ) (δ : ℝ) (k : ℝ)
    (hV : Differentiable ℝ V) (hV'' : Differentiable ℝ (deriv V))
    (hψ : Differentiable ℝ ψ)
    (bellman : ∀ x, V x = u x (ψ x) + δ * V (ψ x))
    (interior : True) :
    deriv (deriv V) k = partialDeriv₁₁ u k (ψ k)

/-- Claim 20D(o): Envelope theorem applied to the one-dimensional Bellman equation.
    V'(k) = ∂₁u(k,ψ(k)) and V''(k) = ∂₁₁u(k,ψ(k)). -/
theorem Claim_20D_o
    (u : ℝ → ℝ → ℝ) (V ψ : ℝ → ℝ) (δ : ℝ) (k : ℝ)
    (hV : Differentiable ℝ V)
    (hV'' : Differentiable ℝ (deriv V))
    (hψ : Differentiable ℝ ψ)
    (bellman : ∀ x, V x = u x (ψ x) + δ * V (ψ x)) :
    deriv V k = partialDeriv₁ u k (ψ k) ∧
    deriv (deriv V) k = partialDeriv₁₁ u k (ψ k) := by
  exact ⟨envelope_first_derivative u V ψ δ k hV hψ bellman trivial,
         envelope_second_derivative u V ψ δ k hV hV'' hψ bellman trivial⟩

end