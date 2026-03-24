import Mathlib

/--
Exercise 4.21: Price–quantity pairs on the demand curve below the competitive
price–quantity pair are not Pareto efficient.

We model this as follows:
- A demand curve D (decreasing) and supply curve S (increasing) cross at (q*, p*).
- At any quantity q < q*, the demand price D(q) exceeds the supply price S(q),
  so there is surplus to be gained by increasing trade — hence the allocation
  is not Pareto efficient.
- "Not Pareto efficient" means there exists a feasible reallocation that yields
  strictly greater total surplus.
-/
theorem Exercise_4_21
    (D S : ℝ → ℝ)
    (q_star : ℝ)
    (hq_star_pos : q_star > 0)
    -- At the competitive equilibrium, demand equals supply price
    (h_eq : D q_star = S q_star)
    -- Demand is strictly decreasing, supply is strictly increasing
    (hD_strict_anti : StrictAnti D)
    (hS_strict_mono : StrictMono S)
    -- Consider a quantity q below the competitive quantity
    (q : ℝ)
    (hq_pos : q ≥ 0)
    (hq_below : q < q_star) :
    -- Then demand price strictly exceeds supply price at q,
    -- meaning gains from trade exist → not Pareto efficient
    D q > S q := by
  have hDq : D q > D q_star := hD_strict_anti hq_below
  have hSq : S q < S q_star := hS_strict_mono hq_below
  rw [h_eq] at hDq
  linarith