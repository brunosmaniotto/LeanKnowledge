import Mathlib

open BigOperators Finset
open Topology

noncomputable section

variable {n : ℕ}

/-- Firm profit: p · f(z) - w · z -/
def firmProfit (f : (Fin n → ℝ) → ℝ) (p : ℝ) (w : Fin n → ℝ)
    (z : Fin n → ℝ) : ℝ :=
  p * f z - ∑ i, w i * z i

/-- Input demand functions x(p,w): the unique profit-maximizing nonneg
    input vector when f is strictly concave (Assumption 3.1). -/
noncomputable def inputDemand (f : (Fin n → ℝ) → ℝ) (p : ℝ)
    (w : Fin n → ℝ) : Fin n → ℝ :=
  Classical.epsilon fun z =>
    (∀ i, 0 ≤ z i) ∧
      ∀ z', (∀ i, 0 ≤ z' i) →
        firmProfit f p w z' ≤ firmProfit f p w z

/-- Output supply function y(p,w) = f(x(p,w)): output at the
    profit-maximizing inputs. -/
noncomputable def outputSupply (f : (Fin n → ℝ) → ℝ) (p : ℝ)
    (w : Fin n → ℝ) : ℝ :=
  f (inputDemand f p w)