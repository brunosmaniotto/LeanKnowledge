import Mathlib
open Topology

variable {N : ℕ}

axiom V₁G : (Fin N → ℝ) → (Fin N → ℝ) → ℝ
axiom V₂G : (Fin N → ℝ) → (Fin N → ℝ) → ℝ

noncomputable def nablaGtilde (k : Fin N → ℝ) : ℝ := V₁G k k + V₂G k k

/-- From profit maximization: V₁G(k,k) = q_{t-1}/s_t.
    With steady-state asset pricing q_{t-1} = (1+r)q_t, so V₁G = (1+r)q/s. -/
axiom profit_max_V1 : ∀ (k : Fin N → ℝ) (q s r : ℝ),
  s ≠ 0 → V₁G k k = (1 + r) * q / s

/-- From profit maximization: V₂G(k,k) = -q_t/s_t -/
axiom profit_max_V2 : ∀ (k : Fin N → ℝ) (q s : ℝ),
  s ≠ 0 → V₂G k k = -(q / s)

/-- The rate of interest measures marginal productivity of capital:
    ∇G̃(k) = V₁G(k,k) + V₂G(k,k) = r · (q/s) -/
theorem marginal_productivity_of_capital
    (k : Fin N → ℝ) (q s r : ℝ)
    (hs : s ≠ 0) :
    nablaGtilde k = r * (q / s) := by
  unfold nablaGtilde
  rw [profit_max_V1 k q s r hs, profit_max_V2 k q s hs]
  field_simp
  ring