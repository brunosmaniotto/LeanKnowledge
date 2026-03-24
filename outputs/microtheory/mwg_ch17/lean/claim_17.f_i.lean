import Mathlib

open Set
open Topology
open BigOperators

/-- Condition (17.F.3) implies the convexity of the equilibrium price set {p : z(p) = 0}. -/
theorem equilibrium_price_set_convex
    {L : Type*} [Fintype L]
    (z : (L → ℝ) → (L → ℝ))
    (h_homog : ∀ (p : L → ℝ) (t : ℝ), 0 < t → z (t • p) = z p)
    (h_walras : ∀ (p : L → ℝ), ∑ l : L, p l * z p l = 0)
    (h_cont : Continuous z)
    (h_condition : ∀ (p q : L → ℝ) (t : ℝ), 0 ≤ t → t ≤ 1 →
      z p = 0 → z q = 0 → z (t • p + (1 - t) • q) = 0) :
    Convex ℝ {p : L → ℝ | z p = 0} := by
  intro p hp q hq t s ht hs hts
  simp only [mem_setOf_eq] at hp hq ⊢
  have hts_pos : t + s = 1 := by linarith
  have hs_eq : s = 1 - t := by linarith
  rw [hs_eq]
  exact h_condition p q t ht (by linarith) hp hq