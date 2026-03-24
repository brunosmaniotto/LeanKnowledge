import Mathlib
open Topology

theorem Claim_20D_e
    (lam : ℕ → ℝ) (δ : ℝ)
    (hfoc : ∀ t : ℕ, lam (t + 1) = δ * lam t)
    : ∀ t : ℕ, lam t = δ ^ t * lam 0 := by
  intro t
  induction t with
  | zero => simp
  | succ n ih =>
    rw [hfoc n, ih, pow_succ]
    ring