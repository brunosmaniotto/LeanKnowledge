import Mathlib

open Subgroup

theorem normal_iInf {ι : Sort*} {G : Type*} [Group G] (N : ι → Subgroup G) (hN : ∀ i, (N i).Normal) :
    (⨅ i, N i).Normal := by
  refine ⟨fun n hn g => ?_⟩
  simp_rw [mem_iInf] at hn ⊢
  intro i
  exact (hN i).conj_mem n (hn i) g