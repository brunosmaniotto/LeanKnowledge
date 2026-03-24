import Mathlib
open Filter

structure MalinvaudPriceSeq where
  price : ℕ → ℝ
  price_nonneg : ∀ t, 0 ≤ price t

def satisfiesTransversality (p : MalinvaudPriceSeq) : Prop :=
  Filter.Tendsto p.price Filter.atTop (nhds 0)