import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A Radner equilibrium for an economy with general asset structure. -/
structure RadnerEquilibrium
    (I : Type*) [Fintype I] [DecidableEq I]
    (S : ℕ) (L : ℕ) (K : ℕ)
    (hL : 0 < L)
    (U : I → (Fin S → Fin L → ℝ) → ℝ)
    (ω : I → Fin S → Fin L → ℝ)
    (r : Fin S → Fin K → ℝ)
    where
  q : Fin K → ℝ
  p : Fin S → Fin L → ℝ
  z : I → Fin K → ℝ
  x : I → Fin S → Fin L → ℝ
  budget_t0 : ∀ i : I,
    ∑ k : Fin K, q k * z i k ≤ 0
  budget_t1 : ∀ (i : I) (s : Fin S),
    ∑ l : Fin L, p s l * x i s l ≤
      ∑ l : Fin L, p s l * ω i s l +
      ∑ k : Fin K, p s ⟨0, hL⟩ * r s k * z i k
  optimality : ∀ (i : I) (z' : Fin K → ℝ) (x' : Fin S → Fin L → ℝ),
    ∑ k : Fin K, q k * z' k ≤ 0 →
    (∀ s : Fin S,
      ∑ l : Fin L, p s l * x' s l ≤
        ∑ l : Fin L, p s l * ω i s l +
        ∑ k : Fin K, p s ⟨0, hL⟩ * r s k * z' k) →
    U i x' ≤ U i (x i)
  asset_clearing : ∀ k : Fin K,
    ∑ i : I, z i k ≤ 0
  goods_clearing : ∀ (s : Fin S) (l : Fin L),
    ∑ i : I, x i s l ≤ ∑ i : I, ω i s l