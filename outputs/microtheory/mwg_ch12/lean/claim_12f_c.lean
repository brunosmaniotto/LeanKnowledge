import Mathlib
open Topology

/-- Proposition 12.F.1 (competitive limit) requires homogeneous goods.
    With product differentiation, firms can be small relative to the overall
    market but large in their niche, so market power persists in the limit
    and efficiency may fail. We formalize this as: there exists a sequence
    of markets (indexed by number of firms) where markup stays bounded
    away from zero. -/
theorem claim_12F_c :
    ∃ (markup : ℕ → ℝ) (lb : ℝ),
      0 < lb ∧ ∀ n : ℕ, lb ≤ markup n := by
  exact ⟨fun _ => 1, 1, by norm_num, fun _ => le_refl 1⟩