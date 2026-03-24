import Mathlib

open BigOperators Finset
open Topology

/-- Exercise 4.1: With identical homothetic preferences, market demand depends
    only on aggregate income and has unit income elasticity. -/
theorem exercise_4_1
    {I : Type*} [Fintype I]
    {L : Type*}
    -- d(p) is the common per-unit-income demand function (from homotheticity)
    (d : (L → ℝ) → L → ℝ)
    -- Individual demand
    (x : I → (L → ℝ) → ℝ → L → ℝ)
    -- Identical homothetic preferences ⟹ demand is linear in income
    (hx : ∀ i p w l, x i p w l = w * d p l)
    -- Market (aggregate) demand
    (X : (L → ℝ) → (I → ℝ) → L → ℝ)
    (hX : ∀ p w l, X p w l = ∑ i, x i p (w i) l) :
    -- (i) Market demand depends only on aggregate income
    (∀ p w w', (∑ i : I, w i) = (∑ i : I, w' i) → ∀ l, X p w l = X p w' l) ∧
    -- (ii) Unit income elasticity: scaling all incomes by t scales demand by t
    (∀ p w (t : ℝ) l, X p (fun i => t * w i) l = t * X p w l) := by
  refine ⟨fun p w w' hW l => ?_, fun p w t l => ?_⟩
  · -- (i) Factor out d(p,l), then use equal aggregate incomes
    simp_rw [hX, hx, ← Finset.sum_mul, hW]
  · -- (ii) Reassociate t*(w_i*d), then fold back into t*Σ
    simp_rw [hX, hx, mul_assoc, Finset.mul_sum]