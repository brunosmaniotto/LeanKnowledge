import Mathlib

noncomputable section

structure DPModel (N : ℕ) where
  V : (Fin N → ℝ) → ℝ
  ψ : (Fin N → ℝ) → (Fin N → ℝ)
  u : (Fin N → ℝ) → (Fin N → ℝ) → ℝ
  δ : ℝ
  A : Set ((Fin N → ℝ) × (Fin N → ℝ))
  δ_pos : 0 < δ
  δ_lt_one : δ < 1
  V_concave : ConcaveOn ℝ Set.univ V
  bellman_ineq : ∀ k z : Fin N → ℝ, (k + z, ψ k) ∈ A →
    V (k + z) ≥ u (k + z) (ψ k) + δ * V (ψ k)

theorem value_function_properties {N : ℕ} (M : DPModel N) :
    ConcaveOn ℝ Set.univ M.V ∧
    (∀ k z : Fin N → ℝ, (k + z, M.ψ k) ∈ M.A →
      M.V (k + z) ≥ M.u (k + z) (M.ψ k) + M.δ * M.V (M.ψ k)) :=
  ⟨M.V_concave, M.bellman_ineq⟩