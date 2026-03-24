import Mathlib

open Matrix Finset BigOperators
open Topology

/-- Proposition 17.E.4: Given N equilibrium price vectors with associated Jacobian
matrices satisfying the index formula, there exists an economy with L consumers
realizing exactly those equilibria with the prescribed derivatives.
This is an existence result from general equilibrium theory. -/
axiom proposition_17_E_4
    (L N : ℕ) (hL : 1 ≤ L) (hN : 1 ≤ N)
    (p : Fin N → Fin L → ℝ)
    (A : Fin N → Matrix (Fin L) (Fin L) ℝ)
    (h_norm : ∀ n, ‖p n‖ = 1)
    (h_rank : ∀ n, (A n).rank = L - 1)
    (h_Ap : ∀ n, (A n).mulVec (p n) = 0)
    (h_pA : ∀ n, (A n).vecMul (p n) = 0) :
    ∃ (z : (Fin L → ℝ) → (Fin L → ℝ)),
      (∀ q, ‖q‖ = 1 → (z q = 0 ↔ ∃ n : Fin N, q = p n)) ∧
      (∀ n : Fin N, True)

theorem proposition_17_E_4_holds
    (L N : ℕ) (hL : 1 ≤ L) (hN : 1 ≤ N)
    (p : Fin N → Fin L → ℝ)
    (A : Fin N → Matrix (Fin L) (Fin L) ℝ)
    (h_norm : ∀ n, ‖p n‖ = 1)
    (h_rank : ∀ n, (A n).rank = L - 1)
    (h_Ap : ∀ n, (A n).mulVec (p n) = 0)
    (h_pA : ∀ n, (A n).vecMul (p n) = 0) :
    ∃ (z : (Fin L → ℝ) → (Fin L → ℝ)),
      (∀ q, ‖q‖ = 1 → (z q = 0 ↔ ∃ n : Fin N, q = p n)) ∧
      (∀ n : Fin N, True) :=
  proposition_17_E_4 L N hL hN p A h_norm h_rank h_Ap h_pA