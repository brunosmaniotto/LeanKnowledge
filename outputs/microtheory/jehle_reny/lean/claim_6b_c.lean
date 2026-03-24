import Mathlib

theorem Claim_6B_c
    (W : ℝ × ℝ → ℝ) (hW_cont : Continuous W) (ua ub : ℝ)
    (hW_mono1 : ∀ y a b, a < b → W (a, y) < W (b, y))
    (hW_mono2 : ∀ x a b, a < b → W (x, a) < W (x, b)) :
    ((∀ x y, ua < x → y < ub → W (ua, ub) < W (x, y)) →
     (∀ x y, x < ua → ub < y → W (x, y) < W (ua, ub)) →
     ∀ p : ℝ × ℝ, W p = W (ua, ub) → p.2 = ub) ∧
    ((∀ x y, ua < x → y < ub → W (x, y) < W (ua, ub)) →
     (∀ x y, x < ua → ub < y → W (ua, ub) < W (x, y)) →
     ∀ p : ℝ × ℝ, W p = W (ua, ub) → p.1 = ua) := by
  constructor
  · intro hII hIV ⟨x, y⟩ hind
    show y = ub
    by_contra hne
    rcases lt_or_gt_of_ne hne with hy | hy
    · rcases lt_trichotomy x ua with hx | rfl | hx
      · linarith [hW_mono1 y x ua hx, hW_mono2 ua y ub hy]
      · linarith [hW_mono2 x y ub hy]
      · linarith [hII x y hx hy]
    · rcases lt_trichotomy x ua with hx | rfl | hx
      · linarith [hIV x y hx hy]
      · linarith [hW_mono2 x ub y hy]
      · linarith [hW_mono1 ub ua x hx, hW_mono2 x ub y hy]
  · intro hII hIV ⟨x, y⟩ hind
    show x = ua
    by_contra hne
    rcases lt_or_gt_of_ne hne with hx | hx
    · rcases lt_trichotomy y ub with hy | rfl | hy
      · linarith [hW_mono1 y x ua hx, hW_mono2 ua y ub hy]
      · linarith [hW_mono1 y x ua hx]
      · linarith [hIV x y hx hy]
    · rcases lt_trichotomy y ub with hy | rfl | hy
      · linarith [hII x y hx hy]
      · linarith [hW_mono1 y ua x hx]
      · linarith [hW_mono1 y ua x hx, hW_mono2 ua ub y hy]