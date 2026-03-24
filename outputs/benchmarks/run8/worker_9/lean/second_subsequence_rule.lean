import Mathlib

open Filter Set Topology Bornology Metric

theorem Second_Subsequence_Rule {M : Type u} [MetricSpace M] {x : ℕ → M}
    (h : ∃ (s : ℕ → ℕ), StrictMono s ∧ ¬ Bornology.IsBounded (Set.range (x ∘ s))) :
    ∀ a : M, ¬ Tendsto x atTop (𝓝 a) := by
  intro a h_conv
  rcases h with ⟨s, hs_mono, h_unbounded⟩
  have h_bdd : Bornology.IsBounded (Set.range x) :=
    Metric.isBounded_range_of_tendsto (u := x) h_conv
  have h_sub : Set.range (x ∘ s) ⊆ Set.range x := by
    intro y hy
    rcases hy with ⟨n, rfl⟩
    exact ⟨s n, rfl⟩
  have h_bdd_sub : Bornology.IsBounded (Set.range (x ∘ s)) :=
    h_bdd.subset h_sub
  exact h_unbounded h_bdd_sub