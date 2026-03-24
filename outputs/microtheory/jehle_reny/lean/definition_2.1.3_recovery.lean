import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Recovery of the direct utility function from the indirect utility function.
    u(x) = inf_{p >> 0} v(p, p · x), where the infimum is over all strictly
    positive price vectors p ∈ ℝⁿ₊₊. (Jehle & Reny, Definition 2.1.3) -/
noncomputable def recoverDirectUtility (n : ℕ)
    (v : (Fin n → ℝ) → ℝ → ℝ)   -- indirect utility function v(p, y)
    (x : Fin n → ℝ) : ℝ :=
  ⨅ (p : Fin n → ℝ) (_ : ∀ i, 0 < p i), v p (∑ i : Fin n, p i * x i)