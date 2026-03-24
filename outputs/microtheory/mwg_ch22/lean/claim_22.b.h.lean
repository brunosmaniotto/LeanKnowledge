import Mathlib
open Topology

theorem first_best_ups_may_be_nonconvex :
    ∃ (S : Set (ℝ × ℝ)), ¬Convex ℝ S ∧ S.Nonempty := by
  refine ⟨{((1 : ℝ), (0 : ℝ)), ((0 : ℝ), (1 : ℝ))}, ?_, ⟨(1, 0), Set.mem_insert _ _⟩⟩
  intro h
  have h1 : ((1 : ℝ), (0 : ℝ)) ∈ ({((1 : ℝ), (0 : ℝ)), ((0 : ℝ), (1 : ℝ))} : Set (ℝ × ℝ)) :=
    Set.mem_insert _ _
  have h2 : ((0 : ℝ), (1 : ℝ)) ∈ ({((1 : ℝ), (0 : ℝ)), ((0 : ℝ), (1 : ℝ))} : Set (ℝ × ℝ)) :=
    Set.mem_insert_iff.mpr (Or.inr rfl)
  have hmid := h h1 h2 (by linarith : (0 : ℝ) ≤ 1/2) (by linarith : (0 : ℝ) ≤ 1/2)
    (by ring : (1 : ℝ)/2 + 1/2 = 1)
  have heq : (1/2 : ℝ) • ((1 : ℝ), (0 : ℝ)) + (1/2 : ℝ) • ((0 : ℝ), (1 : ℝ)) = ((1/2 : ℝ), (1/2 : ℝ)) := by
    ext <;> simp <;> ring
  rw [heq] at hmid
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hmid
  -- Avoid rcases on Prod equality. Instead use Prod.ext_iff to convert to component equalities.
  cases hmid with
  | inl h => exact absurd (congr_arg Prod.fst h) (by norm_num)
  | inr h => exact absurd (congr_arg Prod.fst h) (by norm_num)