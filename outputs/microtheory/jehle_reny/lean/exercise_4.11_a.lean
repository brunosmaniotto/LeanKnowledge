import Mathlib

open Real
open Topology

/-- In a Cournot market with J identical firms, inverse demand p(Q) = a - b·Q,
    and cost c(q) = k + c·q (k > 0, b > 0, a > c > 0), the symmetric equilibrium has:
    - each firm's output: q_J = (a - c) / ((J + 1) · b)
    - market price: p_J = (a + J · c) / (J + 1)
    - total output: Q_J = J · (a - c) / ((J + 1) · b)
    - each firm's profit: π_J = (a - c)² / ((J + 1)² · b) - k -/
theorem Exercise_4_11_a
    (a b c k : ℝ) (J : ℝ)
    (hb : b > 0) (ha : a > c) (hc : c > 0) (hk : k > 0) (hJ : J ≥ 1) :
    let q_J := (a - c) / ((J + 1) * b)
    let Q_J := J * q_J
    let p_J := a - b * Q_J
    let profit_J := p_J * q_J - (k + c * q_J)
    -- (1) Price equals (a + J·c)/(J+1)
    p_J = (a + J * c) / (J + 1) ∧
    -- (2) Total output equals J·(a-c)/((J+1)·b)
    Q_J = J * (a - c) / ((J + 1) * b) ∧
    -- (3) Each firm's profit equals (a-c)²/((J+1)²·b) - k
    profit_J = (a - c) ^ 2 / ((J + 1) ^ 2 * b) - k := by
  have hJ1 : J + 1 > 0 := by linarith
  have hJ1ne : J + 1 ≠ 0 := by linarith
  have hbne : b ≠ 0 := by linarith
  have hJ1b : (J + 1) * b > 0 := by positivity
  have hJ1bne : (J + 1) * b ≠ 0 := by linarith
  have hJ1sq : (J + 1) ^ 2 > 0 := by positivity
  have hJ1sqb : (J + 1) ^ 2 * b > 0 := by positivity
  have hJ1sqbne : (J + 1) ^ 2 * b ≠ 0 := by linarith
  refine ⟨?_, ?_, ?_⟩
  · -- Price = (a + J·c)/(J+1)
    field_simp
    ring
  · -- Total output = J·(a-c)/((J+1)·b)
    ring
  · -- Profit = (a-c)²/((J+1)²·b) - k
    field_simp
    ring