import Mathlib
open Topology

/-- A function g : (Fin N → ℝ) → ℝ is homothetic if there exist a homogeneous function f
    of some degree r and a strictly monotone function h such that g = h ∘ f. -/
def IsHomothetic {N : ℕ} (g : (Fin N → ℝ) → ℝ) : Prop :=
  ∃ (r : ℤ) (f : (Fin N → ℝ) → ℝ) (h : ℝ → ℝ),
    (∀ (t : ℝ), t > 0 → ∀ (x : Fin N → ℝ), f (fun i => t * x i) = t ^ r * f x) ∧
    StrictMono h ∧
    (∀ (x : Fin N → ℝ), g x = h (f x))