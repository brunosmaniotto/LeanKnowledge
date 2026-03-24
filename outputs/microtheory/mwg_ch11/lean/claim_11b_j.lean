import Mathlib
open Topology

-- Let φ₁ and φ₂ be functions from ℝ to ℝ representing utility functions.
variables (φ₁ φ₂ : ℝ → ℝ)

/-
The problem states:
Consumer 2 solves Max_{h≥0,T} φ₂(h) + T subject to φ₁(h) − T ≥ φ₁(0).
The constraint binds, giving T = φ₁(h) − φ₁(0).
Substituting T into the objective, consumer 2's problem reduces to
Max_{h≥0} φ₂(h) + φ₁(h) − φ₁(0).
The solution is h = h°, the socially optimal level.

This implies that finding the h that maximizes φ₂(h) + φ₁(h) − φ₁(0)
is equivalent to finding the h that maximizes φ₁(h) + φ₂(h) (the socially optimal level).
We formalize this by proving the equivalence of the `is_maximizer` property for both functions.
-/

/--
`is_maximizer f S h₀` means that `h₀` is an element of the set `S` and
for all `h'` in `S`, `f h'` is less than or equal to `f h₀`.
-/
def is_maximizer (f : ℝ → ℝ) (S : Set ℝ) (h₀ : ℝ) : Prop :=
  h₀ ∈ S ∧ ∀ h' ∈ S, f h' ≤ f h₀