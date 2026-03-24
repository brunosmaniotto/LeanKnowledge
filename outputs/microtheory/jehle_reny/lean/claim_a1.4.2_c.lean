import Mathlib

open Set

theorem claim_A1_4_2_c
    {D : Set ℝ} {f : ℝ → ℝ}
    (hD : Convex ℝ D)
    (x1 : ℝ) (hx1 : x1 ∈ D)
    (x2 : ℝ) (hx2 : x2 ∈ D)
    (t : ℝ) (ht0 : 0 ≤ t) (ht1 : t ≤ 1)
    (hstrict : f (t * x1 + (1 - t) * x2) < t * f x1 + (1 - t) * f x2) :
    ¬ ConcaveOn ℝ D f := by
  intro hconc
  have h1t : 0 ≤ 1 - t := by linarith
  have ht_add : t + (1 - t) = 1 := by ring
  have := hconc.2 hx1 hx2 ht0 h1t ht_add
  simp [smul_eq_mul] at this
  linarith