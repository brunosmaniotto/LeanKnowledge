import Mathlib
open Topology

/-- Tarski's Fixed Point Theorem: A nondecreasing function on [0,1]^N has a fixed point. -/
theorem Theorem_M_I_3
    {N : Type*} [Fintype N]
    (f : (N → Set.Icc (0:ℝ) 1) → (N → Set.Icc (0:ℝ) 1))
    (hf : Monotone f) :
    ∃ x : N → Set.Icc (0:ℝ) 1, f x = x := by
  let f' : OrderHom (N → Set.Icc (0:ℝ) 1) (N → Set.Icc (0:ℝ) 1) := ⟨f, hf⟩
  exact ⟨f'.lfp, f'.map_lfp⟩