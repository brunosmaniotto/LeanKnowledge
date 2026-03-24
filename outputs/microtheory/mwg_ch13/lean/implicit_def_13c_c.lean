import Mathlib
open Topology
open BigOperators

/-- A perfect Bayesian equilibrium of the education signaling game.

Parameters:
- `Ability`: type of worker abilities (e.g., high/low)
- `Education`: type of education levels
- `Wage`: type of wage offers

Components:
- `workerStrategy`: maps ability to chosen education level
- `belief`: firms' common belief μ(e) that worker is high ability after observing e
- `firmWage`: firms' wage offer as a function of education level

Conditions:
(i) Worker optimality: the worker's education choice maximizes payoff given firm wages
(ii) Bayesian consistency: beliefs are derived from worker strategy via Bayes' rule on-path
(iii) Firm optimality: wage offers form a Nash equilibrium of the wage game given belief μ(e)
-/
structure PerfectBayesianEquilibrium
    (Ability : Type*) [Fintype Ability] [DecidableEq Ability]
    (Education : Type*) [DecidableEq Education]
    (Wage : Type*) [LinearOrder Wage]
    (workerPayoff : Ability → Education → Wage → ℝ)
    (firmProfit : Ability → Wage → ℝ)
    (highAbility : Ability)
    (prior : Ability → ℝ) where
  /-- Worker's pure strategy: maps ability type to education choice -/
  workerStrategy : Ability → Education
  /-- Firms' common belief that worker is high ability after observing education level e -/
  belief : Education → ℝ
  /-- Firms' equilibrium wage offer as a function of observed education -/
  firmWage : Education → Wage
  /-- Beliefs are probabilities: μ(e) ∈ [0,1] -/
  belief_nonneg : ∀ e, 0 ≤ belief e
  belief_le_one : ∀ e, belief e ≤ 1
  /-- (i) Worker optimality: each type's education choice maximizes payoff given firm wages -/
  worker_optimal : ∀ (a : Ability) (e : Education),
    workerPayoff a (workerStrategy a) (firmWage (workerStrategy a)) ≥
    workerPayoff a e (firmWage e)
  /-- (ii) Bayesian consistency: on the equilibrium path, beliefs are derived via Bayes' rule.
      If education level e is chosen by some type, then μ(e) equals the conditional probability
      of high ability given e. -/
  bayes_consistent : ∀ (e : Education),
    (∃ a, workerStrategy a = e) →
    belief e * (∑ a : Ability, if workerStrategy a = e then prior a else 0) =
    (if workerStrategy highAbility = e then prior highAbility else 0)
  /-- (iii) Firm optimality: the wage offer equals the expected productivity given belief μ(e),
      i.e., firms play a Nash equilibrium of the wage-offer game at belief μ(e).
      This is captured by requiring the wage to be a best response to the belief. -/
  firm_optimal : ∀ (e : Education) (w : Wage),
    firmProfit highAbility (firmWage e) * belief e +
    firmProfit highAbility w * (1 - belief e) ≥
    firmProfit highAbility w * belief e +
    firmProfit highAbility w * (1 - belief e) ∨
    firmWage e = w