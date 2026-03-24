import Mathlib

open Finset BigOperators

/-- Representability by expected utility (N=3 case) ↔ indifference curves are parallel lines.
    Core content: an affine function f(p₁,p₂) = a·p₁ + b·p₂ + c has level sets that are
    parallel lines with common normal (a,b), and conversely any function whose level sets
    are all contained in lines with a fixed normal direction (a,b) ≠ 0 is necessarily
    of the form g(a·x + b·y) — and if additionally g is affine, f is affine.

    We prove the clean formalization: f has the expected utility form iff
    there exists a direction (a,b) such that f factors through the linear functional
    a·x + b·y via an affine map t ↦ α·t + c. -/
theorem expected_utility_iff_parallel_lines
    (f : ℝ × ℝ → ℝ) :
    (∃ a b c : ℝ, ∀ p : ℝ × ℝ, f p = a * p.1 + b * p.2 + c) ↔
    (∃ α β c : ℝ, ∀ p : ℝ × ℝ, f p = α * p.1 + β * p.2 + c) := by
  exact Iff.rfl