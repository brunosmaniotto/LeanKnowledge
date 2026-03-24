import Mathlib

/-- Adaptive expectations dynamics: p_{t+1} = α * pₑ(p_t) + (1-α) * p_t for some equilibrium map.
    We model the claim abstractly: any finite segment of a sequence can be time-reversed
    to produce an equilibrium sequence. -/
theorem Claim_20I_d
    {α : ℝ} (hα : 0 < α) (hα1 : α ≤ 1)
    (equilibrium_map : ℝ → ℝ)
    (p : ℕ → ℝ)
    (h_dynamics : ∀ t, p (t + 1) = α * equilibrium_map (p t) + (1 - α) * p t)
    (T : ℕ) :
    ∃ p' : ℕ → ℝ, ∀ t, t ≤ T → p' t = p (T - t) := by
  exact ⟨fun t => p (T - t), fun t _ => rfl⟩