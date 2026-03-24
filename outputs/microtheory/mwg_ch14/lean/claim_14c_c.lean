import Mathlib
open Topology

inductive State
  | H
  | L

theorem first_best_observable_type
    (marginalBenefit : ℝ → ℝ)
    (marginalCost : State → ℝ → ℝ)
    (e_H e_L : ℝ)
    (h_opt_H : marginalBenefit e_H = marginalCost State.H e_H)
    (h_opt_L : marginalBenefit e_L = marginalCost State.L e_L)
    (h_mb_decreasing : ∀ e₁ e₂, e₁ < e₂ → marginalBenefit e₂ < marginalBenefit e₁)
    (h_mc_increasing : ∀ s e₁ e₂, e₁ < e₂ → marginalCost s e₁ < marginalCost s e₂)
    (h_mc_lower_H : ∀ e, marginalCost State.H e < marginalCost State.L e) :
    e_L < e_H := by
  by_contra h
  push_neg at h
  rcases h.eq_or_lt with heq | hlt
  · -- Case e_H = e_L: rewrite e_L → e_H in h_opt_L using ← heq
    rw [← heq] at h_opt_L
    have h3 := h_mc_lower_H e_H
    linarith
  · -- Case e_H < e_L
    have h1 := h_mb_decreasing e_H e_L hlt
    have h2 := h_mc_lower_H e_L
    have h3 := h_mc_increasing State.H e_H e_L hlt
    linarith