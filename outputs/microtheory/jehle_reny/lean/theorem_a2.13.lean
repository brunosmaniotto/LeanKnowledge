import Mathlib
open Set Filter Topology
open Topology

/-- Theorem A2.13 (MWG): For a concave function on a convex domain D, the following
    are equivalent at an interior point x*: (1) f'(x*) = 0, (2) x* is a local maximum,
    (3) x* is a global maximum on D. Proved as cyclic implications (1)→(3)→(2)→(1). -/
theorem Theorem_A2_13
    {f : ℝ → ℝ} {D : Set ℝ} {x_star : ℝ}
    (hf : ConcaveOn ℝ D f)
    (hx_int : x_star ∈ interior D)
    (hf_diff : DifferentiableAt ℝ f x_star)
    -- First-order condition for concave functions (Theorem A2.4):
    -- f(y) ≤ f(x*) + f'(x*)(y - x*) for all y ∈ D
    (hfoc : ∀ y ∈ D, f y ≤ f x_star + deriv f x_star * (y - x_star)) :
    -- (1) ⇒ (3): zero derivative → global max on D
    (deriv f x_star = 0 → IsMaxOn f D x_star) ∧
    -- (3) ⇒ (2): global max on D → local max
    (IsMaxOn f D x_star → IsLocalMax f x_star) ∧
    -- (2) ⇒ (1): local max → zero derivative (Fermat's theorem / Theorem A2.9)
    (IsLocalMax f x_star → deriv f x_star = 0) := by
  refine ⟨?_, ?_, ?_⟩
  · -- (1) ⇒ (3): f'(x*) = 0 implies x* is a global max
    intro hderiv y hy
    have h := hfoc y hy
    rw [hderiv, zero_mul, add_zero] at h
    exact h
  · -- (3) ⇒ (2): global max on D implies local max (since x* ∈ interior D)
    intro h
    filter_upwards [mem_interior_iff_mem_nhds.mp hx_int] with y hy
    exact h hy
  · -- (2) ⇒ (1): local max implies f'(x*) = 0
    exact fun h => h.hasDerivAt_eq_zero hf_diff.hasDerivAt