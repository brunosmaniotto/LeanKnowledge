import Mathlib

open Matrix Finset
open Topology

/-- The inverse function theorem setup: special case of the implicit function theorem
    where M = N and every equation has the form f_n(x, q) = g_n(x) - q_n = 0. -/
def MWG.IsInverseFunctionTheoremForm
    {n : ℕ}
    (g : (Fin n → ℝ) → (Fin n → ℝ))
    (f : (Fin n → ℝ) → (Fin n → ℝ) → (Fin n → ℝ)) : Prop :=
  ∀ (x q : Fin n → ℝ) (i : Fin n), f x q i = g x i - q i