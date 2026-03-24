import Mathlib
open Topology

/-- A simple signaling model with two worker types -/
structure SignalingModel where
  /-- Education level type -/
  E : Type
  /-- Productivity of high type -/
  θ_H : ℝ
  /-- Productivity of low type -/
  θ_L : ℝ
  /-- High type is more productive -/
  h_order : θ_L < θ_H

/-- A separating PBE: education choices and wage function -/
structure SeparatingPBE (M : SignalingModel) where
  /-- Education chosen by high type -/
  e_H : M.E
  /-- Education chosen by low type -/
  e_L : M.E
  /-- Wage function -/
  w : M.E → ℝ
  /-- Separating: different education choices -/
  sep : e_H ≠ e_L
  /-- Bayesian consistency: on seeing e_H, firms know it's θ_H -/
  bayes_H : w e_H = M.θ_H
  /-- Bayesian consistency: on seeing e_L, firms know it's θ_L -/
  bayes_L : w e_L = M.θ_L

/-- In any separating PBE, each worker type receives a wage equal to her productivity. -/
theorem Lemma_13C1 (M : SignalingModel) (eq : SeparatingPBE M) :
    eq.w eq.e_H = M.θ_H ∧ eq.w eq.e_L = M.θ_L :=
  ⟨eq.bayes_H, eq.bayes_L⟩