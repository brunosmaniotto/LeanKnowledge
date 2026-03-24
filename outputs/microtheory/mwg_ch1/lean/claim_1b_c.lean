import Mathlib
open Topology

theorem utility_representation_finite
    {X : Type*} [Fintype X] [DecidableEq X]
    (R : X → X → Prop) [DecidableRel R]
    (htotal : ∀ x y, R x y ∨ R y x)
    (htrans : ∀ x y z, R x y → R y z → R x z) :
    ∃ u : X → ℝ, ∀ x y : X, R x y ↔ u x ≤ u y := by
  refine ⟨fun x => ((Finset.univ.filter (fun z => R z x)).card : ℝ), fun x y => ?_⟩
  constructor
  · intro hxy
    show ((Finset.univ.filter (fun z => R z x)).card : ℝ) ≤
         ((Finset.univ.filter (fun z => R z y)).card : ℝ)
    have hsub : Finset.univ.filter (fun z => R z x) ⊆ Finset.univ.filter (fun z => R z y) := by
      intro z hz
      simp only [Finset.mem_filter] at hz ⊢
      exact ⟨hz.1, htrans z x y hz.2 hxy⟩
    exact_mod_cast Finset.card_le_card hsub
  · intro hle
    by_contra hnxy
    have hyx : R y x := (htotal x y).resolve_left hnxy
    have hsub : Finset.univ.filter (fun z => R z y) ⊆ Finset.univ.filter (fun z => R z x) := by
      intro z hz
      simp only [Finset.mem_filter] at hz ⊢
      exact ⟨hz.1, htrans z y x hz.2 hyx⟩
    have hrefl : R x x := (htotal x x).elim id id
    have hmem : x ∈ Finset.univ.filter (fun z => R z x) :=
      Finset.mem_filter.mpr ⟨Finset.mem_univ _, hrefl⟩
    have hnotin : x ∉ Finset.univ.filter (fun z => R z y) :=
      fun h => hnxy (Finset.mem_filter.mp h).2
    have hlt := Finset.card_lt_card ⟨hsub, fun h => hnotin (h hmem)⟩
    have hle' : ((Finset.univ.filter (fun z => R z x)).card : ℝ) ≤
                ((Finset.univ.filter (fun z => R z y)).card : ℝ) := by
      show ((Finset.univ.filter (fun z => R z x)).card : ℝ) ≤
           ((Finset.univ.filter (fun z => R z y)).card : ℝ)
      exact hle
    have : (Finset.univ.filter (fun z => R z x)).card ≤ (Finset.univ.filter (fun z => R z y)).card := by
      exact_mod_cast hle'
    omega