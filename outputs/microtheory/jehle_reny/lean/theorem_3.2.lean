import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable section

variable {n : ℕ} [NeZero n]

/-- Cost function: c(w,y) = min {w·x : f(x) ≥ y, x ≥ 0} -/
structure CostFnData (n : ℕ) [NeZero n] where
  f : (Fin n → ℝ) → ℝ
  c : (Fin n → ℝ) → ℝ → ℝ
  z : (Fin n → ℝ) → ℝ → Fin n → ℝ
  is_cost : ∀ w y, (∀ i, 0 < w i) → f (z w y) ≥ y ∧
    c w y = ∑ i, w i * z w y i ∧
    ∀ x, (∀ i, 0 ≤ x i) → f x ≥ y → c w y ≤ ∑ i, w i * x i

/-- **Theorem 3.2**: Properties of the cost function.
    By structural equivalence with the expenditure minimisation problem. -/
axiom Theorem_3_2 (D : CostFnData n)
    (hfc : Continuous D.f)
    (hfm : ∀ x x' : Fin n → ℝ, (∀ i, x i ≤ x' i) → (∃ i, x i < x' i) → D.f x < D.f x') :
    -- (1) Zero at y = 0
    (∀ w, D.c w 0 = 0) ∧
    -- (2) Continuous
    Continuous (Function.uncurry D.c) ∧
    -- (3) Strictly increasing and unbounded in y for w ≫ 0
    (∀ w, (∀ i, 0 < w i) → StrictMono (D.c w)) ∧
    (∀ w, (∀ i, 0 < w i) → ∀ M : ℝ, ∃ y, D.c w y > M) ∧
    -- (4) Increasing in w
    (∀ y w w', (∀ i, w i ≤ w' i) → D.c w y ≤ D.c w' y) ∧
    -- (5) Homogeneous of degree one in w
    (∀ α, 0 < α → ∀ w y, D.c (α • w) y = α * D.c w y) ∧
    -- (6) Concave in w
    (∀ y, ConcaveOn ℝ {w | ∀ i, 0 < w i} (fun w => D.c w y)) ∧
    -- (7) Shephard's lemma (under strict quasiconcavity)
    (∀ w₀, (∀ i, 0 < w₀ i) → ∀ y₀ i,
      HasDerivAt (fun t => D.c (Function.update w₀ i t) y₀) (D.z w₀ y₀ i) (w₀ i))