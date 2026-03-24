import Mathlib
open Topology
open Finset

/-- Under symmetric information, there is a trade-off between requiring high versus low effort:
    - Lower effort allows a higher price (d(0) < d(1)), increasing profits
    - Higher effort reduces expected loss (by MLRP shifting probability toward lower losses)
    The optimal effort level depends on which effect dominates. -/
structure EffortTradeoff where
  /-- Number of loss levels -/
  n : ℕ
  /-- Loss levels -/
  loss : Fin n → ℝ
  /-- Probability of each loss level given effort e ∈ {0, 1} -/
  π : Fin 2 → Fin n → ℝ
  /-- Disutility of effort -/
  d : Fin 2 → ℝ
  /-- Price (premium) as a function of effort -/
  price : Fin 2 → ℝ
  /-- Probabilities are nonneg -/
  π_nonneg : ∀ e i, 0 ≤ π e i
  /-- Lower effort has lower disutility: d(0) < d(1) -/
  d_low_lt_high : d 0 < d 1
  /-- Price is higher when effort is lower (since d(0) < d(1) means less disutility
      to compensate, so the company can charge more) -/
  price_low_effort_higher : price 0 > price 1
  /-- MLRP: higher effort shifts probability toward lower losses -/
  expected_loss_high_effort_lower :
    Finset.sum Finset.univ (fun i => π 1 i * loss i) ≤
    Finset.sum Finset.univ (fun i => π 0 i * loss i)

/-- The two effects of changing effort on profit go in opposite directions,
    so the optimal effort depends on which effect dominates. -/
theorem effort_tradeoff (M : EffortTradeoff) :
    (M.price 0 > M.price 1) ∧
    (Finset.sum Finset.univ (fun i => M.π 1 i * M.loss i) ≤
     Finset.sum Finset.univ (fun i => M.π 0 i * M.loss i)) :=
  ⟨M.price_low_effort_higher, M.expected_loss_high_effort_lower⟩