import Mathlib

open Set
open Real

theorem bounded_iff_bounded' (s : Set ℝ) :
    (∃ L H, ∀ x ∈ s, L ≤ x ∧ x ≤ H) ↔ ∃ K, ∀ x ∈ s, |x| ≤ K := by
  constructor
  · intro h
    rcases h with ⟨L, H, h⟩
    set K := max (|L|) (|H|) with hK_def
    use K
    intro x hx
    rcases h x hx with ⟨hL, hH⟩
    -- Get the inequalities: -|L| ≤ L ≤ |L| and -|H| ≤ H ≤ |H|
    have hL_lower : -|L| ≤ L := by
      have := (abs_le.mp (le_refl (|L|))).left
      exact this
    have hH_upper : H ≤ |H| := by
      have := (abs_le.mp (le_refl (|H|))).right
      exact this
    have hK1 : |L| ≤ K := le_max_left _ _
    have hK2 : |H| ≤ K := le_max_right _ _
    -- Combine to show -K ≤ x ≤ K
    have h_lower : -K ≤ x := by linarith
    have h_upper : x ≤ K := by linarith
    exact abs_le.mpr ⟨h_lower, h_upper⟩
  · intro h
    rcases h with ⟨K, h⟩
    use -K, K
    intro x hx
    have hx_abs : |x| ≤ K := h x hx
    exact abs_le.mp hx_abs