import Mathlib
open Topology

structure RecursiveUtility (α : Type*) where
  u : α → ℝ
  G : ℝ → ℝ → ℝ

noncomputable def recV {α : Type*} (ru : RecursiveUtility α) : (ℕ → α) → ℕ → ℝ
  | _, 0     => 0
  | c, n + 1 => ru.G (ru.u (c 0)) (recV ru (fun i => c (i + 1)) n)

/-- Equation 20.B.3: V(c, n+1) = G(u(c₀), V(tail c, n)) -/
theorem Eq_20B3 {α : Type*} (ru : RecursiveUtility α) (c : ℕ → α) (n : ℕ) :
    recV ru c (n + 1) = ru.G (ru.u (c 0)) (recV ru (fun i => c (i + 1)) n) := by
  rfl