import Mathlib
open Topology
open BigOperators

-- Formalizing the efficiency condition for optimal allocation of goods across consumers.
-- Condition 16.F.4: At a Pareto optimal allocation, marginal rates of substitution
-- are equalized across all consumers, which is the FOC of the constrained optimization.

/-- The efficiency condition for allocation of aggregate goods across consumers:
    Given I consumers and L goods, at an interior Pareto optimal allocation,
    the marginal rates of substitution between any two goods are equalized
    across all consumers. This is the first-order condition for maximizing
    one consumer's utility subject to utility constraints on others and
    resource constraints. We state this as: there exist positive multipliers
    (μ_i) such that μ_i * ∇u_i(x_i) is the same vector for all consumers i. -/
theorem efficiency_equalized_MRS
    {I L : ℕ} (hI : 0 < I) (hL : 0 < L)
    -- Utility functions for each consumer
    (u : Fin I → (Fin L → ℝ) → ℝ)
    -- Marginal utilities (gradients)
    (Du : Fin I → (Fin L → ℝ) → (Fin L → ℝ))
    -- The allocation
    (x : Fin I → Fin L → ℝ)
    -- Aggregate endowments
    (X_bar : Fin L → ℝ)
    -- Resource feasibility: for each good, allocations sum to endowment
    (feasible : ∀ ℓ : Fin L, ∑ i : Fin I, x i ℓ = X_bar ℓ)
    -- Optimality: x maximizes u_1 subject to constraints
    -- (i.e., x is a solution to the constrained problem)
    -- Interior solution with positive marginal utilities
    (interior : ∀ i : Fin I, ∀ ℓ : Fin L, 0 < Du i (x i) ℓ)
    -- FOC hypothesis: there exist positive Lagrange multipliers μ_i
    -- such that weighted marginal utilities are equalized
    (hFOC : ∃ μ : Fin I → ℝ, (∀ i, 0 < μ i) ∧
      ∀ i : Fin I, ∀ ℓ : Fin L, μ i * Du i (x i) ℓ = μ ⟨0, hI⟩ * Du ⟨0, hI⟩ (x ⟨0, hI⟩) ℓ) :
    -- Conclusion: MRS between any two goods is equalized across consumers
    ∀ (i j : Fin I) (ℓ k : Fin L),
      Du i (x i) ℓ / Du i (x i) k = Du j (x j) ℓ / Du j (x j) k := by
  obtain ⟨μ, hμpos, hμeq⟩ := hFOC
  intro i j ℓ k
  have hμi : μ i ≠ 0 := ne_of_gt (hμpos i)
  have hμj : μ j ≠ 0 := ne_of_gt (hμpos j)
  have hDik : Du i (x i) k ≠ 0 := ne_of_gt (interior i k)
  have hDjk : Du j (x j) k ≠ 0 := ne_of_gt (interior j k)
  -- From FOC: μ_i * Du_i(x_i)(ℓ) = μ_0 * Du_0(x_0)(ℓ) for all i, ℓ
  -- So μ_i * Du_i(x_i)(ℓ) = μ_j * Du_j(x_j)(ℓ)
  have eq_ℓ : μ i * Du i (x i) ℓ = μ j * Du j (x j) ℓ := by
    rw [hμeq i ℓ, hμeq j ℓ]
  have eq_k : μ i * Du i (x i) k = μ j * Du j (x j) k := by
    rw [hμeq i k, hμeq j k]
  -- Du_i(ℓ)/Du_i(k) = Du_j(ℓ)/Du_j(k) follows from cross-multiplication
  rw [div_eq_div_iff hDik hDjk]
  -- Goal: Du i (x i) ℓ * Du j (x j) k = Du j (x j) ℓ * Du i (x i) k
  have h1 : μ i * Du i (x i) ℓ * (μ j * Du j (x j) k) =
             μ j * Du j (x j) ℓ * (μ i * Du i (x i) k) := by
    rw [eq_ℓ, eq_k]
  nlinarith [hμpos i, hμpos j, interior i ℓ, interior j ℓ, interior i k, interior j k]