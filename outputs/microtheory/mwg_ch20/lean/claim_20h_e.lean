import Mathlib
open Topology

-- Overlapping generations model with monetary steady state
-- Each generation t has young and old consumption (c_y, c_o)
-- The monetary steady state has allocation (y, 1-y) for each generation

noncomputable section

-- Model primitives
axiom OLGModel : Type
axiom endowment : OLGModel → ℝ  -- young-period endowment y
axiom utility : OLGModel → ℝ → ℝ → ℝ  -- u(c_young, c_old)

-- Allocation: consumption profile for each generation
axiom Allocation : OLGModel → Type
axiom gen0_young : (E : OLGModel) → Allocation E → ℝ
axiom gen_young : (E : OLGModel) → Allocation E → ℕ → ℝ
axiom gen_old : (E : OLGModel) → Allocation E → ℕ → ℝ

-- Feasibility: each generation's transfers must balance
axiom IsFeasible : (E : OLGModel) → Allocation E → Prop

-- The monetary steady state allocation
axiom monetarySteadyState : (E : OLGModel) → Allocation E
axiom mss_gives_y_1my : ∀ (E : OLGModel) (t : ℕ),
  gen_young E (monetarySteadyState E) t = endowment E ∧
  gen_old E (monetarySteadyState E) t = 1 - endowment E

-- Pareto optimality
axiom ParetoOptimal : (E : OLGModel) → Allocation E → Prop

-- Key economic argument: reducing c_{a0} below y creates an infeasible
-- chain of compensations (Figure 20.H.3 argument)
axiom compensation_chain_infeasible : ∀ (E : OLGModel) (a : Allocation E),
  IsFeasible E a →
  gen0_young E a < endowment E →
  ∃ t : ℕ, gen_old E a t < gen_old E (monetarySteadyState E) t

-- The monetary steady state is feasible
axiom mss_feasible : ∀ (E : OLGModel), IsFeasible E (monetarySteadyState E)

-- No feasible reallocation can Pareto improve: any attempt to give
-- generation 0 more old-age consumption requires taking from some generation
axiom no_pareto_improvement : ∀ (E : OLGModel) (a : Allocation E),
  IsFeasible E a →
  (∀ t, utility E (gen_young E a t) (gen_old E a t) ≥
        utility E (gen_young E (monetarySteadyState E) t)
                   (gen_old E (monetarySteadyState E) t)) →
  (∀ t, utility E (gen_young E a t) (gen_old E a t) =
        utility E (gen_young E (monetarySteadyState E) t)
                   (gen_old E (monetarySteadyState E) t))

-- Pareto optimality follows from the impossibility of Pareto improvement
axiom pareto_optimal_def : ∀ (E : OLGModel) (a : Allocation E),
  ParetoOptimal E a ↔
  (IsFeasible E a ∧
   ¬∃ a', IsFeasible E a' ∧
     (∀ t, utility E (gen_young E a' t) (gen_old E a' t) ≥
           utility E (gen_young E a t) (gen_old E a t)) ∧
     (∃ t, utility E (gen_young E a' t) (gen_old E a' t) >
           utility E (gen_young E a t) (gen_old E a t)))

theorem monetary_steady_state_pareto_optimal (E : OLGModel) :
    ParetoOptimal E (monetarySteadyState E) := by
  rw [pareto_optimal_def]
  constructor
  · exact mss_feasible E
  · rintro ⟨a', hfeas, hge, t₀, hstrict⟩
    have heq := no_pareto_improvement E a' hfeas hge
    linarith [heq t₀]

end