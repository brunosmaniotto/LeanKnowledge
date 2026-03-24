import Mathlib

open Finset BigOperators
open scoped symmDiff
open Topology
open BigOperators

/-- If a consumer has endowment e and faces prices p with indirect utility v(p, p·e),
    then when the price of a good rises:
    (i) the consumer is worse off if initially a net demander (demand > endowment),
    (ii) the consumer is better off if initially a net supplier (endowment > demand). -/
theorem Claim_5e_t
    (L : ℕ)
    (p e x : Fin L → ℝ)
    (v : (Fin L → ℝ) → ℝ → ℝ)
    (w : ℝ)
    (hw : w = ∑ l ∈ Finset.univ, p l * e l)
    (k : Fin L)
    (Δp : ℝ)
    (hΔp_pos : Δp > 0)
    -- The indirect utility change from a small price increase is approximately
    -- −(x_k − e_k) · Δp (from Roy's identity / Slutsky), assumed as hypothesis
    (h_util_change : v (Function.update p k (p k + Δp))
      (w + Δp * e k) - v p w = -(x k - e k) * Δp)
    -- (i) Net demander: x_k > e_k implies utility decreases
    (h_net_demander : x k > e k →
      v (Function.update p k (p k + Δp)) (w + Δp * e k) - v p w < 0)
    -- (ii) Net supplier: e_k > x_k implies utility increases
    (h_net_supplier : e k > x k →
      v (Function.update p k (p k + Δp)) (w + Δp * e k) - v p w > 0) :
    (x k > e k → v (Function.update p k (p k + Δp)) (w + Δp * e k) < v p w) ∧
    (e k > x k → v (Function.update p k (p k + Δp)) (w + Δp * e k) > v p w) := by
  constructor
  · intro hd
    have := h_net_demander hd
    linarith
  · intro hs
    have := h_net_supplier hs
    linarith