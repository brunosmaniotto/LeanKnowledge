import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- An investor with initial wealth w allocates β to a risky asset with returns rᵢ.
    Final wealth under outcome i is (w − β) + (1 + rᵢ)β = w + βrᵢ,
    and the expected utility objective Σpᵢu((w−β)+(1+rᵢ)β) simplifies to Σpᵢu(w+βrᵢ). -/
theorem Example_2_6 {n : ℕ} (w β : ℝ) (r : Fin n → ℝ) (p : Fin n → ℝ)
    (u : ℝ → ℝ) :
    (∀ i : Fin n, (w - β) + (1 + r i) * β = w + β * r i)
    ∧ ∑ i : Fin n, p i * u ((w - β) + (1 + r i) * β) =
      ∑ i : Fin n, p i * u (w + β * r i) := by
  refine ⟨fun i => by ring, Finset.sum_congr rfl fun i _ => ?_⟩
  congr 1
  ring