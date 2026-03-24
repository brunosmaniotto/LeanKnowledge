import Mathlib
open Topology

theorem insurance_actuarially_fair
    (w D π : ℝ)
    (hπ_pos : 0 < π) (hπ_lt : π < 1)
    (u' : ℝ → ℝ)
    (h_strict_mono : StrictAntiOn u' Set.univ)
    (α : ℝ)
    (h_foc : u' (w - D + α * (1 - π)) = u' (w - α * π)) :
    α = D := by
  have h_inj : ∀ a b : ℝ, u' a = u' b → a = b := by
    intro a b hab
    by_contra h
    cases ne_iff_lt_or_gt.mp h with
    | inl hlt =>
      exact absurd hab (ne_of_gt (h_strict_mono (Set.mem_univ a) (Set.mem_univ b) hlt))
    | inr hgt =>
      exact absurd hab (ne_of_lt (h_strict_mono (Set.mem_univ b) (Set.mem_univ a) hgt))
  have h_eq := h_inj _ _ h_foc
  linarith