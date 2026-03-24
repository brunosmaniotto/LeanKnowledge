import Mathlib

open BigOperators Finset

noncomputable section

/-- Infinite-horizon production economy -/
structure InfiniteHorizonEconomy where
  δ : ℝ
  hδ_pos : 0 < δ
  hδ_lt : δ < 1
  u : ℝ → ℝ
  ω : ℕ → ℝ
  inY : (ℝ × ℝ) → Prop

/-- Production path -/
structure ProdPath (E : InfiniteHorizonEconomy) where
  y : ℕ → ℝ × ℝ
  feasible : ∀ t, E.inY (y t)

def consumption (E : InfiniteHorizonEconomy) (p : ProdPath E) (t : ℕ) : ℝ :=
  (if t = 0 then 0 else (p.y (t - 1)).1) + (p.y t).2 + E.ω t