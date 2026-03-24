import Mathlib

open Finset BigOperators
open Topology

variable {n : ℕ}

/-- The derivative of the Hicksian demand equals the derivative of the Slutsky compensated demand.
    This follows from Shephard's lemma: ∇_p e(p, ū) = h(p, ū) and the fact that at the optimum
    h(p, ū) = x(p, w). -/
theorem hicksian_slutsky_compensated_demand_derivative
    (p : Fin n → ℝ)          -- price vector
    (w : ℝ)                   -- wealth
    (u : ℝ)                   -- utility level
    (x : Fin n → ℝ)          -- Walrasian demand x(p, w)
    (h : Fin n → ℝ)          -- Hicksian demand h(p, ū)
    (grad_e : Fin n → ℝ)     -- ∇_p e(p, ū)
    -- Shephard's lemma: ∇_p e(p, ū) = h(p, ū)
    (shephard : grad_e = h)
    -- At the optimum, Hicksian demand equals Walrasian demand: h(p, ū) = x(p, w)
    (optimality : h = x) :
    grad_e = x := by
  rw [shephard, optimality]