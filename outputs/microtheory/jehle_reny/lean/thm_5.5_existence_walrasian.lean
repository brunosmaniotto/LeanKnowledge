import Mathlib
open Topology BigOperators Finset Filter
open Filter
open BigOperators

/-- Assumption 5.1: Consumer utility on ℝⁿ₊ is continuous, strongly increasing,
    and strictly quasiconcave. -/
structure Assn_5_1_ConsumerUtility {n : ℕ} (u : (Fin n → ℝ) → ℝ) : Prop where
  continuous : Continuous u
  strongly_increasing : ∀ x y, (∀ i, x i ≤ y i) → x ≠ y → (∀ i, x i < y i) → u x < u y
  strictly_quasiconcave : ∀ x y α, 0 < α → α < 1 → u ((1 - α) • x + α • y) > min (u x) (u y)

variable {L : ℕ} [Fintype (Fin L)] [NeZero L]
variable {I : Type*} [Fintype I] [Nonempty I]

-- Axiom for Theorem 5.4: If each consumer's utility function satisfies Assumption 5.1,
-- then there exists an aggregate excess demand function z with certain properties.
axiom Thm_5_4_excess_demand_properties_axiom
    (u : I → (Fin L → ℝ) → ℝ)
    (e : I → (Fin L → ℝ))
    (hu : ∀ i, Assn_5_1_ConsumerUtility (u i))
    : ∃ (z : (Fin L → ℝ) → (Fin L → ℝ)),
        Continuous z ∧
        (∀ (p : Fin L → ℝ) (t : ℝ), 0 < t → z (t • p) = z p) ∧ -- Homogeneity of degree zero
        (∀ p : Fin L → ℝ, (∀ l, 0 ≤ p l) → (∑ l : Fin L, p l * (z p) l) = 0) ∧ -- Walras' Law
        (∀ (p_n : ℕ → (Fin L → ℝ)),
          (∀ n l, 0 ≤ p_n n l) → -- non-negative prices
          (∃ l_0 : Fin L, Tendsto (fun n => p_n n l_0) atTop (nhds (0 : ℝ))) → -- some price tends to zero
          (∃ (l_1 : Fin L), Tendsto (fun n => (z (p_n n)) l_1) atTop atTop)) -- some excess demand tends to infinity

-- Axiom for Theorem 5.3: Existence of a Walrasian equilibrium given properties of z
-- and a strictly positive aggregate endowment.
axiom Thm_5_3_existence_walrasian_axiom
    (e : I → (Fin L → ℝ))
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (z_continuous : Continuous z)
    (z_homogeneous_degree_zero : ∀ (p : Fin L → ℝ) (t : ℝ), 0 < t → z (t • p) = z p)
    (z_walras_law : ∀ p : Fin L → ℝ, (∀ l, 0 ≤ p l) → (∑ l : Fin L, p l * (z p) l) = 0)
    (z_boundary_condition : ∀ (p_n : ℕ → (Fin L → ℝ)),
      (∀ n l, 0 ≤ p_n n l) →
      (∃ l_0 : Fin L, Tendsto (fun n => p_n n l_0) atTop (nhds (0 : ℝ))) →
      (∃ (l_1 : Fin L), Tendsto (fun n => (z (p_n n)) l_1) atTop atTop))
    (aggregate_endowment_strictly_positive : ∀ l, 0 < (∑ i : I, e i l))
    : ∃ p_star : (Fin L → ℝ), (∀ l, 0 < p_star l) ∧ (z p_star = 0)

/-- Theorem 5.5: If each consumer's utility function satisfies Assumption 5.1 and the
    aggregate endowment is strictly positive, then there exists an aggregate excess demand
    function z with certain properties, and there exists at least one p* ≫ 0
    such that z(p*) = 0. -/
theorem Thm_5_5_existence_walrasian
    (u : I → (Fin L → ℝ) → ℝ)
    (e : I → (Fin L → ℝ))
    (hu : ∀ i, Assn_5_1_ConsumerUtility (u i))
    (h_agg_endowment : ∀ l, 0 < (∑ i : I, e i l))
    : ∃ (z : (Fin L → ℝ) → (Fin L → ℝ)),
        (Continuous z ∧
        (∀ (p : Fin L → ℝ) (t : ℝ), 0 < t → z (t • p) = z p) ∧
        (∀ p : Fin L → ℝ, (∀ l, 0 ≤ p l) → (∑ l : Fin L, p l * (z p) l) = 0) ∧
        (∀ (p_n : ℕ → (Fin L → ℝ)),
          (∀ n l, 0 ≤ p_n n l) →
          (∃ l_0 : Fin L, Tendsto (fun n => p_n n l_0) atTop (nhds (0 : ℝ))) →
          (∃ (l_1 : Fin L), Tendsto (fun n => (z (p_n n)) l_1) atTop atTop))) ∧
        (∃ p_star : (Fin L → ℝ), (∀ l, 0 < p_star l) ∧ (z p_star = 0)) := by
  -- By Theorem 5.4, conditions 1–3 of Theorem 5.3 hold for some z.
  obtain ⟨z_func, h_z_props⟩ := Thm_5_4_excess_demand_properties_axiom u e hu
  let ⟨z_continuous, z_homogeneous_degree_zero, z_walras_law, z_boundary_condition⟩ := h_z_props

  -- We use this z_func and its properties to satisfy the premise of Theorem 5.3.
  use z_func
  constructor
  . exact h_z_props
  . exact Thm_5_3_existence_walrasian_axiom e z_func z_continuous z_homogeneous_degree_zero z_walras_law z_boundary_condition h_agg_endowment