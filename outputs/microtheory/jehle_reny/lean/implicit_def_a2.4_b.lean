import Mathlib

open Set
open Topology

noncomputable section

/-- The value function V(a) for the parameterised maximisation problem:
    V(a) = sup{f(x, a) : x ∈ ℝⁿ, gⱼ(x, a) ≤ 0 for all j}.
    When the maximum exists and x(a) is a solution, V(a) = f(x(a), a). -/
noncomputable def MWG.valueFunction {n m : ℕ}
    (f : (Fin n → ℝ) → (Fin m → ℝ) → ℝ)
    (g : Fin m → (Fin n → ℝ) → (Fin m → ℝ) → ℝ)
    (a : Fin m → ℝ) : ℝ :=
  sSup {v : ℝ | ∃ x : Fin n → ℝ, (∀ j : Fin m, g j x a ≤ 0) ∧ f x a = v}

end