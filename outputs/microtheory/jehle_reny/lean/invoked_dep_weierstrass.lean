import Mathlib
open Topology

theorem weierstrass_theorem
    {α : Type*} [TopologicalSpace α]
    {S : Set α} {f : α → ℝ}
    (hS_compact : IsCompact S) (hS_nonempty : S.Nonempty)
    (hf_cont : ContinuousOn f S) :
    ∃ x_max ∈ S, ∃ x_min ∈ S, ∀ x ∈ S, f x_min ≤ f x ∧ f x ≤ f x_max := by
  obtain ⟨x_max, hx_max_mem, hx_max⟩ := hS_compact.exists_isMaxOn hS_nonempty hf_cont
  obtain ⟨x_min, hx_min_mem, hx_min⟩ := hS_compact.exists_isMinOn hS_nonempty hf_cont
  exact ⟨x_max, hx_max_mem, x_min, hx_min_mem, fun x hx =>
    ⟨hx_min hx, hx_max hx⟩⟩