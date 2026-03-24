import Mathlib

open Finset BigOperators
open Topology

/-- Demand derived from Gorman-form indirect utility via Roy's identity
    is affine (linear) in wealth w. -/
theorem gorman_linear_engel
    {L : ℕ}
    (a : (Fin L → ℝ) → ℝ)       -- a(p)
    (b : (Fin L → ℝ) → ℝ)       -- b(p)
    (da : Fin L → (Fin L → ℝ) → ℝ) -- ∂a/∂p_ℓ
    (db : Fin L → (Fin L → ℝ) → ℝ) -- ∂b/∂p_ℓ
    (p : Fin L → ℝ)
    (hb : b p ≠ 0)
    (ℓ : Fin L) :
    -- Demand from Roy's identity: x_ℓ(p,w) = -(da_ℓ(p) + db_ℓ(p)*w) / b(p)
    -- This is affine in w: there exist α, β (independent of w) such that x(w) = α + β * w
    ∃ α β : ℝ, ∀ w : ℝ,
      -(da ℓ p + db ℓ p * w) / b p = α + β * w := by
  refine ⟨-(da ℓ p / b p), -(db ℓ p / b p), fun w => ?_⟩
  field_simp
  ring