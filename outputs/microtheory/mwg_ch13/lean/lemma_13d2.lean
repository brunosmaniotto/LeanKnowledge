import Mathlib
open Topology

structure ScreeningGame where
  theta_L : ℝ
  theta_H : ℝ
  mix : ℝ
  cost : ℝ → ℝ → ℝ
  h_theta : theta_L < theta_H
  h_mix_pos : 0 < mix
  h_mix_lt : mix < 1
  single_crossing :
    ∀ w t : ℝ, theta_L < w → w < theta_H →
      ∃ t' : ℝ,
        (w - cost t' theta_H > w - cost t theta_H) ∧
        (w - cost t theta_L > w - cost t' theta_L)

structure Contract where
  w : ℝ
  t : ℝ

structure PoolingEquilibrium (G : ScreeningGame) where
  c : Contract
  break_even : c.w = (1 - G.mix) * G.theta_L + G.mix * G.theta_H
  no_profitable_deviation :
    ∀ (c' : Contract),
      (c'.w - G.cost c'.t G.theta_H > c.w - G.cost c.t G.theta_H) →
      (c.w - G.cost c.t G.theta_L > c'.w - G.cost c'.t G.theta_L) →
      c'.w ≥ G.theta_H

theorem Lemma_13D2 (G : ScreeningGame) : IsEmpty (PoolingEquilibrium G) := by
  rw [isEmpty_iff]
  intro ⟨c, break_even, no_profitable_deviation⟩
  have hw_lt : c.w < G.theta_H := by
    rw [break_even]; nlinarith [G.h_theta, G.h_mix_lt]
  have hlt_w : G.theta_L < c.w := by
    rw [break_even]; nlinarith [G.h_theta, G.h_mix_pos]
  obtain ⟨t', ht'H, ht'L⟩ := G.single_crossing c.w c.t hlt_w hw_lt
  have h := no_profitable_deviation ⟨c.w, t'⟩ ht'H ht'L
  linarith