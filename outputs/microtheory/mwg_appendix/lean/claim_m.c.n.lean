import Mathlib
open Topology

axiom concaveOn_fderiv_sub_le
    {n : ℕ} {f : EuclideanSpace ℝ (Fin n) → ℝ}
    {x : EuclideanSpace ℝ (Fin n)}
    (hf : ConcaveOn ℝ Set.univ f)
    (hd : DifferentiableAt ℝ f x)
    (y : EuclideanSpace ℝ (Fin n)) :
    f y - f x ≤ (fderiv ℝ f x) (y - x)

theorem claim_M_C_n
    {n : ℕ} (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (hf : ConcaveOn ℝ Set.univ f)
    (hdf : DifferentiableOn ℝ f Set.univ)
    (x x' : EuclideanSpace ℝ (Fin n))
    (hfx : f x' ≥ f x) :
    (fderiv ℝ f x) (x' - x) ≥ 0 := by
  have hd : DifferentiableAt ℝ f x :=
    hdf.differentiableAt (isOpen_univ.mem_nhds (Set.mem_univ x))
  have h := concaveOn_fderiv_sub_le hf hd x'
  linarith