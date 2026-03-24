import Mathlib

/-
  Bellman equation for dynamic programming (MWG 20.D.11):
  V(k) = max_{k' : (k,k') ∈ A} [u(k,k') + δ·V(k')]
  with uniqueness of V under boundedness.
-/

noncomputable section

-- State space and feasibility correspondence
variable {S : Type*} [Nonempty S]

-- Feasible transition set
variable (A : S → Set S)

-- Period return function and discount factor
variable (u : S → S → ℝ) (δ : ℝ)

-- Assume discount factor in (0,1)
variable (hδ_pos : 0 < δ) (hδ_lt : δ < 1)

-- Assume feasible sets are nonempty
variable (hA : ∀ k, (A k).Nonempty)

-- The Bellman operator
def bellmanOp (V : S → ℝ) (k : S) : ℝ :=
  iSup (fun (k' : A k) => u k (↑k') + δ * V (↑k'))

-- A value function satisfies the Bellman equation if it is a fixed point of the operator