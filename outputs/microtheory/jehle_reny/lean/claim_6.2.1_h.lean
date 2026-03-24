import Mathlib
open Topology

theorem Claim_6_2_1_h
    (W : ℝ × ℝ → ℝ)
    (ubar : ℝ × ℝ)
    (RegionII : Set (ℝ × ℝ))
    (hne : RegionII.Nonempty)
    (hinv : ∀ u ∈ RegionII, ∀ v ∈ RegionII,
      (W ubar < W u ↔ W ubar < W v) ∧
      (W ubar = W u ↔ W ubar = W v)) :
    (∀ u ∈ RegionII, W ubar > W u) ∨
    (∀ u ∈ RegionII, W ubar = W u) ∨
    (∀ u ∈ RegionII, W ubar < W u) := by
  obtain ⟨u₀, hu₀⟩ := hne
  rcases lt_trichotomy (W ubar) (W u₀) with h | h | h
  · right; right; exact fun v hv => (hinv u₀ hu₀ v hv).1.mp h
  · right; left; exact fun v hv => (hinv u₀ hu₀ v hv).2.mp h
  · left; intro v hv
    rcases lt_trichotomy (W ubar) (W v) with hlt | heq | hgt
    · linarith [(hinv u₀ hu₀ v hv).1.mpr hlt]
    · linarith [(hinv u₀ hu₀ v hv).2.mpr heq]
    · exact hgt