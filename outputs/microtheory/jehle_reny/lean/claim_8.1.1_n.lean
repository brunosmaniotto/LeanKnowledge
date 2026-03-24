import Mathlib
open Topology

/-- A strictly convex function cannot have three distinct fixed points,
    so equilibrium p* = g(p*) has at most two solutions. -/
theorem claim_8_1_1_n
    (g : ℝ → ℝ) (S : Set ℝ)
    (hg : StrictConvexOn ℝ S g)
    (a b c : ℝ) (ha : a ∈ S) (hb : b ∈ S) (hc : c ∈ S)
    (hab : a < b) (hbc : b < c)
    (hfa : g a = a) (hfb : g b = b) (hfc : g c = c) : False := by
  have hac : a ≠ c := by linarith
  have hca_pos : (0 : ℝ) < c - a := by linarith
  set t := (c - b) / (c - a)
  set s := (b - a) / (c - a)
  have ht_pos : 0 < t := div_pos (by linarith) hca_pos
  have hs_pos : 0 < s := div_pos (by linarith) hca_pos
  have hts : t + s = 1 := by
    simp only [t, s]
    rw [div_add_div_same]
    have : c - b + (b - a) = c - a := by ring
    rw [this]; exact div_self hca_pos.ne'
  have strict := hg.2 ha hc hac ht_pos hs_pos hts
  simp only [smul_eq_mul] at strict
  have key : t * a + s * c = b := by simp only [t, s]; field_simp; ring
  rw [key, hfa, hfc, hfb] at strict
  linarith