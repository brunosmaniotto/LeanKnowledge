import Mathlib
open Topology

/-- In Example 22.B.6, the locus Q does not coincide with the Pareto set of the
second-best UPS because consumer 2's utility along Q is non-monotone in t. -/
theorem second_best_ups_locus_nonmonotonicity
    (u₂ : ℝ → ℝ) (hu₂_cont : Continuous u₂)
    (hu₂_zero : u₂ 0 = 0)
    (hu₂_one : u₂ 1 = 0)
    (hu₂_pos : ∃ t : ℝ, 0 < t ∧ t < 1 ∧ 0 < u₂ t) :
    ¬ MonotoneOn u₂ (Set.Icc 0 1) ∧ ¬ AntitoneOn u₂ (Set.Icc 0 1) := by
  constructor
  · intro hm
    obtain ⟨t, ht0, ht1, hpos⟩ := hu₂_pos
    have h0 : (0 : ℝ) ∈ Set.Icc (0 : ℝ) 1 := by constructor <;> linarith
    have ht : t ∈ Set.Icc (0 : ℝ) 1 := by constructor <;> linarith
    have h1 : (1 : ℝ) ∈ Set.Icc (0 : ℝ) 1 := by constructor <;> linarith
    have := hm ht h1 (le_of_lt ht1)
    linarith
  · intro hm
    obtain ⟨t, ht0, ht1, hpos⟩ := hu₂_pos
    have h0 : (0 : ℝ) ∈ Set.Icc (0 : ℝ) 1 := by constructor <;> linarith
    have ht : t ∈ Set.Icc (0 : ℝ) 1 := by constructor <;> linarith
    have := hm h0 ht (le_of_lt ht0)
    linarith