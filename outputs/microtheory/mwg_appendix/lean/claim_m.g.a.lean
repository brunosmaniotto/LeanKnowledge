import Mathlib

open Set

theorem Claim_M_G_a {N : ℕ} {A : Set (Fin N → ℝ)} (hA : Convex ℝ A)
    (f : (Fin N → ℝ) → ℝ) (hf : ConcaveOn ℝ A f) :
    Convex ℝ {p : (Fin N → ℝ) × ℝ | p.2 ≤ f p.1 ∧ p.1 ∈ A} := by
  intro ⟨x, vx⟩ ⟨hvx, hxA⟩ ⟨y, vy⟩ ⟨hvy, hyA⟩ a b ha hb hab
  simp only [Set.mem_setOf_eq, Prod.fst, Prod.snd] at *
  constructor
  · calc a • vx + b • vy ≤ a • f x + b • f y := by
          gcongr
    _ ≤ f (a • x + b • y) := hf.2 hxA hyA ha hb hab
  · exact hA hxA hyA ha hb hab