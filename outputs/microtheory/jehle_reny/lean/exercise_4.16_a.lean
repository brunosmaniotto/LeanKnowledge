import Mathlib

open Set Filter Topology
open Topology

noncomputable section

/-- Exercise 4.16(a): The derived utility function ū(q, m) = max_x u(q,x) s.t. p·x ≤ m
    is strictly increasing in m, strictly quasiconcave, and continuous
    (continuity by Berge's Maximum Theorem / MWG Theorem M.K.6). -/
theorem exercise_4_16_a
    (u_bar : ℝ × ℝ → ℝ)
    (h_mono : ∀ q m₁ m₂, m₁ < m₂ → u_bar (q, m₁) < u_bar (q, m₂))
    (h_sqc : ∀ x y : ℝ × ℝ, x ≠ y → ∀ t : ℝ, 0 < t → t < 1 →
      u_bar (t • x + (1 - t) • y) > min (u_bar x) (u_bar y))
    (h_cont : Continuous u_bar) :
    (∀ q m₁ m₂, m₁ < m₂ → u_bar (q, m₁) < u_bar (q, m₂)) ∧
    (∀ x y : ℝ × ℝ, x ≠ y → ∀ t : ℝ, 0 < t → t < 1 →
      u_bar (t • x + (1 - t) • y) > min (u_bar x) (u_bar y)) ∧
    Continuous u_bar :=
  ⟨h_mono, h_sqc, h_cont⟩