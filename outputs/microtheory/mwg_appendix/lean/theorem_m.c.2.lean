import Mathlib
open Topology

/-- Theorem M.C.2 (1D): A C² function on an open convex set is concave iff f'' ≤ 0.
    Strict concavity follows from f'' < 0. -/
theorem Theorem_M_C_2 {f : ℝ → ℝ} {A : Set ℝ}
    (hA_open : IsOpen A) (hA_conv : Convex ℝ A)
    (hf' : DifferentiableOn ℝ f A)
    (hf'' : DifferentiableOn ℝ (deriv f) A) :
    (ConcaveOn ℝ A f ↔ ∀ x ∈ A, deriv^[2] f x ≤ 0) ∧
    ((∀ x ∈ A, deriv^[2] f x < 0) → StrictConcaveOn ℝ A f) := by
  refine ⟨⟨fun hfc x hx => ?_, fun h => concaveOn_of_deriv2_nonpos' hA_conv hf' hf'' h⟩,
    fun h => strictConcaveOn_of_deriv2_neg' hA_conv hf'.continuousOn h⟩
  -- → direction: ConcaveOn → f'' ≤ 0
  -- By concavity, deriv f is antitone on A (Theorem M.C.1 consequence)
  have hfA : ∀ y ∈ A, DifferentiableAt ℝ f y :=
    fun y hy => hf'.differentiableAt (hA_open.mem_nhds hy)
  -- Antitone derivative → derivWithin (deriv f) A x ≤ 0
  have hanti := (hfc.antitoneOn_deriv hfA).derivWithin_nonpos (x := x)
  -- Since A is open, derivWithin = deriv, giving deriv^[2] f x ≤ 0
  rwa [derivWithin_of_mem_nhds (hA_open.mem_nhds hx)] at hanti