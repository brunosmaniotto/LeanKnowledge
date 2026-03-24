import Mathlib
open BigOperators

noncomputable section

abbrev Bundle := Fin 2 → ℝ

structure EdgeworthEconomy where
  pref : Fin 2 → Bundle → Bundle → Prop
  strictPref : Fin 2 → Bundle → Bundle → Prop
  strict_iff : ∀ i x y, strictPref i x y ↔ (pref i x y ∧ ¬ pref i y x)
  pref_cost : ∀ (i : Fin 2) (p : Bundle) (x y : Bundle),
    (∀ k, 0 < p k) → strictPref i x y →
    ∑ k : Fin 2, p k * x k > ∑ k : Fin 2, p k * y k

abbrev Allocation := Fin 2 → Bundle

def Feasible (e : EdgeworthEconomy) (endow : Bundle) (a : Allocation) : Prop :=
  ∀ k : Fin 2, ∑ i : Fin 2, a i k = endow k