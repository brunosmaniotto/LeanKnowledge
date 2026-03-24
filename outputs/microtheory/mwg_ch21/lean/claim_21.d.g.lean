import Mathlib

open Finset
open Topology

theorem median_agent_exists
    {Agent : Type*} [Fintype Agent] [Nonempty Agent] [DecidableEq Agent]
    {Position : Type*} [LinearOrder Position]
    (peak : Agent → Position) :
    ∃ m : Agent,
      2 * (univ.filter (fun i => peak i ≤ peak m)).card ≥ Fintype.card Agent ∧
      2 * (univ.filter (fun i => peak m ≤ peak i)).card ≥ Fintype.card Agent := by
  classical
  have hn : (univ : Finset Agent).card = Fintype.card Agent := card_univ
  set S := univ.filter (fun m : Agent =>
    2 * (univ.filter (fun i => peak i ≤ peak m)).card ≥ Fintype.card Agent)
  have hS_ne : S.Nonempty := by
    obtain ⟨mx, _, hmx⟩ := exists_max_image univ peak univ_nonempty
    refine ⟨mx, mem_filter.mpr ⟨mem_univ _, ?_⟩⟩
    have h : univ.filter (fun i => peak i ≤ peak mx) = univ :=
      eq_univ_of_forall fun a => mem_filter.mpr ⟨mem_univ _, hmx a (mem_univ a)⟩
    rw [h]; omega
  obtain ⟨m, hm_mem, hm_min⟩ := exists_min_image S peak hS_ne
  refine ⟨m, (mem_filter.mp hm_mem).2, ?_⟩
  set R := univ.filter (fun i : Agent => peak m ≤ peak i)
  set L := univ.filter (fun i : Agent => peak i < peak m)
  have hcomp : R.card + L.card = Fintype.card Agent := by
    have h1 : R ∪ L = univ := eq_univ_of_forall fun x => by
      rw [mem_union]
      by_cases h : peak m ≤ peak x
      · exact Or.inl (mem_filter.mpr ⟨mem_univ _, h⟩)
      · exact Or.inr (mem_filter.mpr ⟨mem_univ _, not_le.mp h⟩)
    have h2 : Disjoint R L :=
      disjoint_filter.mpr fun x _ h1 h2 => absurd h2 (not_lt.mpr h1)
    rw [← card_union_of_disjoint h2, h1]; exact hn
  suffices hsuff : 2 * L.card ≤ Fintype.card Agent by omega
  rcases L.eq_empty_or_nonempty with hL | hL
  · simp [hL]
  · obtain ⟨a, ha_mem, ha_max⟩ := exists_max_image L peak hL
    have ha_lt : peak a < peak m := (mem_filter.mp ha_mem).2
    have ha_not_S : a ∉ S := fun hc => absurd ha_lt (not_lt.mpr (hm_min a hc))
    have hbound : 2 * (univ.filter (fun i => peak i ≤ peak a)).card < Fintype.card Agent := by
      by_contra hc; push_neg at hc
      exact ha_not_S (mem_filter.mpr ⟨mem_univ _, hc⟩)
    have hsub : L ⊆ univ.filter (fun i => peak i ≤ peak a) := by
      intro x hx
      have hx_lt : peak x < peak m := (mem_filter.mp hx).2
      have hx_peak : peak x ≤ peak a := ha_max x hx
      exact mem_filter.mpr ⟨mem_univ _, hx_peak⟩
    have hsub_card := card_le_card hsub
    omega