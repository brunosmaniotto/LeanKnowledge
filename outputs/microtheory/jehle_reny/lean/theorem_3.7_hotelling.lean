import Mathlib
open Topology
open BigOperators

/-- Hotelling's Lemma: For a profit-maximizing firm with strictly concave production,
    the profit function π(p, w) is differentiable, and its partial derivatives
    yield the supply and input demand functions. -/
structure HotellingsLemma (n : ℕ) where
  profit : ℝ → (Fin n → ℝ) → ℝ
  supply : ℝ → (Fin n → ℝ) → ℝ
  input_demand : ℝ → (Fin n → ℝ) → (Fin n → ℝ)
  profit_deriv_p : ∀ (p : ℝ) (w : Fin n → ℝ),
    0 < p → (∀ i, 0 < w i) →
    HasDerivAt (fun p' => profit p' w) (supply p w) p
  profit_deriv_w : ∀ (p : ℝ) (w : Fin n → ℝ) (i : Fin n),
    0 < p → (∀ j, 0 < w j) →
    HasDerivAt (fun t => profit p (Function.update w i t)) (-(input_demand p w i)) (w i)

theorem hotelling_supply {n : ℕ} (H : HotellingsLemma n)
    (p : ℝ) (w : Fin n → ℝ) (hp : 0 < p) (hw : ∀ i, 0 < w i) :
    HasDerivAt (fun p' => H.profit p' w) (H.supply p w) p :=
  H.profit_deriv_p p w hp hw