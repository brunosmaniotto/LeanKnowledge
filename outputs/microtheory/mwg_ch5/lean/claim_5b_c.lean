import Mathlib
open Topology

theorem inaction_of_nonincreasing_returns
    {Y : Set (ι → ℝ)}
    (hne : Y.Nonempty)
    (h_nirs : ∀ y ∈ Y, ∀ α : ℝ, 0 ≤ α → α ≤ 1 → α • y ∈ Y) :
    (0 : ι → ℝ) ∈ Y := by
  obtain ⟨y, hy⟩ := hne
  have h := h_nirs y hy 0 le_rfl zero_le_one
  simpa using h