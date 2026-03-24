import Mathlib

open Filter Topology Finset BigOperators
open Topology
open BigOperators
open Finset

/-- Proposition 20.C.1 (MWG): Myopic profit maximization + transversality ⟹ efficiency.

The proof reduces to: if an alternative path strictly dominates, then at each period
there is a nonneg weighted feasibility gap (from positive prices), with at least one
strictly positive. Myopic optimality + telescoping bounds the cumulative gap by a
boundary term. Transversality drives this boundary to zero, contradicting the
positive lower bound. -/
theorem Proposition_20C1
    (fgap : ℕ → ℝ)
    (boundary : ℕ → ℝ)
    (fgap_nonneg : ∀ t, 0 ≤ fgap t)
    (fgap_strict : ∃ t₀, fgap t₀ > 0)
    (telescope : ∀ T, ∑ t ∈ Finset.range (T + 1), fgap t ≤ boundary T)
    (transversality : Tendsto boundary atTop (𝓝 0)) :
    False := by
  obtain ⟨t₀, ht₀⟩ := fgap_strict
  have hev_bound := (tendsto_order.mp transversality).2 (fgap t₀) ht₀
  have hev_large : ∀ᶠ n in atTop, t₀ < n :=
    eventually_atTop.mpr ⟨t₀ + 1, fun n hn => by omega⟩
  obtain ⟨T, hT_bound, hT_large⟩ := (hev_bound.and hev_large).exists
  have hmem : t₀ ∈ Finset.range (T + 1) := Finset.mem_range.mpr (by omega)
  have hsum : fgap t₀ ≤ ∑ t ∈ Finset.range (T + 1), fgap t :=
    Finset.single_le_sum (fun t _ => fgap_nonneg t) hmem
  linarith [telescope T]