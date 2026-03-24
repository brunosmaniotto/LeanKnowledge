import Mathlib

open Filter Topology

theorem lower_bound_of_tendsto {x : ℕ → ℝ} {l a : ℝ} (h_tendsto : Tendsto x atTop (𝓝 l))
    (h_lower : ∀ n, a ≤ x n) : a ≤ l := by
  have h_eventually : ∀ᶠ n in atTop, a ≤ x n := eventually_atTop.mpr ⟨0, fun n _ => h_lower n⟩
  exact ge_of_tendsto h_tendsto h_eventually