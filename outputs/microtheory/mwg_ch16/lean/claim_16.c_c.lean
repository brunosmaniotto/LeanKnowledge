import Mathlib
open Topology

theorem claim_16Cc
    (pref_weak : ℝ → ℝ → Prop)
    (pref_strict : ℝ → ℝ → Prop)
    (strict_def : ∀ a b, pref_strict a b ↔ (pref_weak a b ∧ ¬ pref_weak b a))
    (trans_weak : ∀ a b c, pref_weak a b → pref_weak b c → pref_weak a c)
    (cost : ℝ → ℝ)
    (xstar : ℝ) (w : ℝ)
    (lns : ∀ (x : ℝ) (ε : ℝ), ε > 0 →
      ∃ x', pref_strict x' x ∧ |cost x' - cost x| < ε)
    (equil : ∀ x', pref_strict x' xstar → cost x' ≥ w)
    (x : ℝ) (hx : pref_weak x xstar) :
    cost x ≥ w := by
  by_contra h
  push_neg at h
  set ε := w - cost x with hε_def
  have hε_pos : ε > 0 := by linarith
  obtain ⟨x', hstrict, hcost_close⟩ := lns x ε hε_pos
  -- x' ≻ x means pref_weak x' x ∧ ¬ pref_weak x x'
  rw [strict_def] at hstrict
  obtain ⟨hw_x'_x, hnw_x_x'⟩ := hstrict
  -- x' ≻ x* : pref_weak x' xstar via transitivity, and ¬ pref_weak xstar x'
  have hw_x'_xstar : pref_weak x' xstar := trans_weak x' x xstar hw_x'_x hx
  have hn_xstar_x' : ¬ pref_weak xstar x' := by
    intro h_contra
    -- pref_weak xstar x' and pref_weak x' x gives pref_weak xstar x (not needed directly)
    -- pref_weak x xstar and pref_weak xstar x' gives pref_weak x x', contradicting hnw_x_x'
    exact hnw_x_x' (trans_weak x xstar x' hx h_contra)
  have hstrict_star : pref_strict x' xstar := by
    rw [strict_def]
    exact ⟨hw_x'_xstar, hn_xstar_x'⟩
  have hcost_lt : cost x' < w := by
    rw [abs_lt] at hcost_close
    linarith
  linarith [equil x' hstrict_star]