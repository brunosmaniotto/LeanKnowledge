import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Multigenerational interpretation: if V satisfies V(c) = u(head c) + δ * V(tail c),
    then unrolling n steps gives V(c) = Σ_{t<n} δ^t * u(c t) + δ^n * V(shift c n). -/
theorem multigenerational_bellman_unrolling
    (V : (ℕ → ℝ) → ℝ)
    (u : ℝ → ℝ)
    (δ : ℝ)
    (shift : (ℕ → ℝ) → ℕ → (ℕ → ℝ))
    (shift_zero : ∀ c, shift c 0 = c)
    (head_shift : ∀ c n, shift c n 0 = c n)
    (bellman : ∀ c, V c = u (c 0) + δ * V (fun i => c (i + 1)))
    (shift_tail : ∀ c n, (fun i => (shift c n) (i + 1)) = shift c (n + 1))
    (c : ℕ → ℝ) :
    ∀ n : ℕ, V c = ∑ t ∈ range n, δ ^ t * u (c t) + δ ^ n * V (shift c n) := by
  intro n
  induction n with
  | zero =>
    simp [shift_zero]
  | succ n ih =>
    rw [sum_range_succ]
    have hV : V (shift c n) = u (shift c n 0) + δ * V (fun i => (shift c n) (i + 1)) :=
      bellman (shift c n)
    rw [head_shift] at hV
    rw [shift_tail] at hV
    rw [ih, hV]
    ring