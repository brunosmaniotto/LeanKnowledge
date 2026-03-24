import Mathlib

structure DedekindCut where
  L : Set ℝ
  R : Set ℝ
  mem_or : ∀ x : ℝ, x ∈ L ∨ x ∈ R
  nonempty_L : ∃ x, x ∈ L
  nonempty_R : ∃ x, x ∈ R
  lt_of_mem : ∀ x ∈ L, ∀ y ∈ R, x < y

theorem DedekindCut.exists_unique_producer (cut : DedekindCut) : ∃! x : ℝ,
    (x ∈ cut.L ∧ IsGreatest cut.L x) ∨ (x ∈ cut.R ∧ IsLeast cut.R x) := by
  -- L is bounded above by any element of R
  have hL_bdd : BddAbove cut.L := by
    obtain ⟨r, hr⟩ := cut.nonempty_R
    refine ⟨r, fun x hx => ?_⟩
    have h := cut.lt_of_mem x hx r hr
    linarith
  have hL_ne : Set.Nonempty cut.L := cut.nonempty_L
  set s := sSup cut.L with hs_def
  have hs : IsLUB cut.L s := Real.isLUB_sSup hL_ne hL_bdd
  rcases cut.mem_or s with hL | hR
  · -- Case 1: s ∈ L
    have h_greatest : IsGreatest cut.L s := by
      refine ⟨hL, ?_⟩
      intro x hx
      exact hs.1 hx
    refine ⟨s, Or.inl ⟨hL, h_greatest⟩, ?_⟩
    intro x hx
    rcases hx with (⟨hxL, hx_greatest⟩ | ⟨hxR, hx_least⟩)
    · -- x in L and greatest
      have h1 : x ≤ s := h_greatest.2 hxL
      have h2 : s ≤ x := by
        apply hs.2
        intro y hy
        exact hx_greatest.2 hy
      linarith
    · -- x in R and least
      have h_lt : s < x := cut.lt_of_mem s hL x hxR
      set t := (s + x) / 2 with ht_def
      have hst : s < t := by linarith
      have htx : t < x := by linarith
      rcases cut.mem_or t with htL | htR
      · -- t ∈ L
        have := h_greatest.2 htL
        linarith
      · -- t ∈ R
        have := hx_least.2 htR
        linarith
  · -- Case 2: s ∈ R
    have h_least : IsLeast cut.R s := by
      refine ⟨hR, ?_⟩
      intro y hy
      by_contra! H  -- H: y < s
      have h_ub : y ∈ upperBounds cut.L := by
        intro x hx
        have h_lt := cut.lt_of_mem x hx y hy
        linarith
      have := hs.2 h_ub
      linarith
    refine ⟨s, Or.inr ⟨hR, h_least⟩, ?_⟩
    intro x hx
    rcases hx with (⟨hxL, hx_greatest⟩ | ⟨hxR, hx_least'⟩)
    · -- x in L and greatest
      have h_lt : x < s := cut.lt_of_mem x hxL s hR
      set t := (x + s) / 2 with ht_def
      have hxt : x < t := by linarith
      have hts : t < s := by linarith
      rcases cut.mem_or t with htL | htR
      · -- t ∈ L
        have := hx_greatest.2 htL
        linarith
      · -- t ∈ R
        have := h_least.2 htR
        linarith
    · -- x in R and least
      have h1 : s ≤ x := h_least.2 hxR
      have h2 : x ≤ s := hx_least'.2 hR
      linarith