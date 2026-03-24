import Mathlib

open BigOperators Finset
open Topology

/-- Total variable cost: the optimised cost of variable inputs `w · x(w, w̄, y; x̄)`,
    where `x` is the conditional factor demand for variable inputs. -/
noncomputable def TotalVariableCost
    {n m : ℕ}
    (w : Fin n → ℝ)
    (x : (Fin n → ℝ) → (Fin m → ℝ) → ℝ → (Fin m → ℝ) → (Fin n → ℝ))
    (w_bar : Fin m → ℝ)
    (y : ℝ)
    (x_bar : Fin m → ℝ) : ℝ :=
  ∑ i, w i * x w w_bar y x_bar i

/-- Total fixed cost: the cost of the fixed inputs `w̄ · x̄`. -/
noncomputable def TotalFixedCost
    {m : ℕ}
    (w_bar : Fin m → ℝ)
    (x_bar : Fin m → ℝ) : ℝ :=
  ∑ i, w_bar i * x_bar i