import Mathlib
open Topology

theorem claim_14C_a
    (cost : ℝ → ℝ)
    (utility : ℝ → ℝ)
    (u_bar : ℝ)
    (h_mono_u : StrictMono utility)
    (h_mono_c : StrictMono cost)
    (w : ℝ)
    (h_pc : utility w ≥ u_bar)
    (h_opt : ∀ w', utility w' ≥ u_bar → cost w ≤ cost w')
    (h_surj : Function.Surjective utility)
    : utility w = u_bar := by
  by_contra h
  have h_strict : utility w > u_bar := lt_of_le_of_ne h_pc (Ne.symm h)
  obtain ⟨w', hw'⟩ := h_surj u_bar
  have h_pc' : utility w' ≥ u_bar := ge_of_eq hw'
  have h_opt' : cost w ≤ cost w' := h_opt w' h_pc'
  have h_ww' : w' < w := by
    by_contra h_not_lt
    push_neg at h_not_lt
    rcases lt_or_eq_of_le h_not_lt with h_lt | h_eq
    · exact absurd (h_mono_u h_lt) (by linarith [hw'])
    · linarith [h_eq ▸ hw']
  exact absurd (h_mono_c h_ww') (not_lt.mpr h_opt')