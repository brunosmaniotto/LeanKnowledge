import Mathlib

-- First, let's define what uniform convergence means for our series
def UniformlyConvergent {D : Type*} {V : Type*} [NormedAddCommGroup V] [NormedSpace ℝ V] 
    (f : ℕ → D → V) : Prop :=
  ∀ ε > 0, ∃ N : ℕ, ∀ m n : ℕ, m ≥ N → n ≥ m → ∀ x : D, 
    ‖∑ k ∈ Finset.range (n - m), f (m + k + 1) x‖ < ε

-- The bounded partial sums lemma (trivial as given)