import Mathlib
open Filter Topology
open Topology
set_option linter.unusedVariables false

theorem exercise_6_8_a {N : Type*} [Fintype N] [Nonempty N] (W : (N → ℝ) → ℝ)
    (h_cont : Continuous W) (h_strict_mono : StrictMono W) (u : N → ℝ) (α : ℝ)
    (h_min : ∀ i, α ≤ u i) : W (fun _ => α) ≤ W u := by
  set const_α := (fun _ : N => α) with h_const_def
  have h_lt : ∀ ε > 0, const_α < (fun i => u i + ε) := by
    intro ε hε
    constructor
    · intro i
      dsimp [const_α]
      linarith [h_min i, hε]
    · intro h
      have h' : ∀ i, (fun i => u i + ε) i ≤ const_α i := h
      dsimp [const_α] at h'
      have h0 := h' (Classical.arbitrary N)
      linarith [h_min (Classical.arbitrary N), hε]
  have h_W_lt : ∀ ε > 0, W const_α < W (fun i => u i + ε) :=
    fun ε hε => h_strict_mono (h_lt ε hε)
  let g : ℝ → (N → ℝ) := fun ε i => u i + ε
  have h_cont_g : Continuous g := by
    unfold g
    exact continuous_pi (fun i => by continuity)
  have h_cont_comp : Continuous (W ∘ g) := h_cont.comp h_cont_g
  have h_tendsto : Tendsto (W ∘ g) (𝓝 0) (𝓝 (W (g 0))) :=
    h_cont_comp.continuousAt.tendsto
  have h_tendsto' : Tendsto (W ∘ g) (𝓝[>] 0) (𝓝 (W u)) := by
    simpa [g, add_zero] using h_tendsto.mono_left nhdsWithin_le_nhds
  have h_eventually : ∀ᶠ ε in 𝓝[>] (0 : ℝ), W const_α ≤ (W ∘ g) ε := by
    filter_upwards [self_mem_nhdsWithin] with ε hε
    exact le_of_lt (h_W_lt ε hε)
  exact ge_of_tendsto h_tendsto' h_eventually