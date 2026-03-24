import Mathlib
open Topology

theorem claim_A1_4_2_g
    (f : ℝ → ℝ)
    (hf : StrictConcaveOn ℝ (Set.univ) f)
    (a b : ℝ) (hab : a < b) :
    ¬ (∀ x, x ∈ Set.Icc a b → f x = f a) := by
  intro hconst
  have hb_mem : b ∈ Set.Icc a b := by constructor <;> linarith
  have h := hf.2 (Set.mem_univ a) (Set.mem_univ b) (ne_of_lt hab)
    (by linarith : (0:ℝ) < 1/2) (by linarith : (0:ℝ) < 1/2)
    (by ring : (1:ℝ)/2 + 1/2 = 1)
  have hfb : f b = f a := hconst b hb_mem
  have hmid_mem : (1:ℝ)/2 * a + (1:ℝ)/2 * b ∈ Set.Icc a b := by
    constructor <;> nlinarith
  have hfmid : f ((1:ℝ)/2 * a + (1:ℝ)/2 * b) = f a := hconst _ hmid_mem
  simp only [smul_eq_mul] at h
  linarith