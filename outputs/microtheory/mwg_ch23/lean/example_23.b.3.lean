import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Ex post efficiency in the bridge-building mechanism: the social choice function
    that builds when sum of valuations exceeds cost, with transfers summing to -c·k,
    maximizes total surplus. -/
theorem Example_23B3
    {I : ℕ} (hI : 0 < I)
    (θ : Fin I → ℝ) (c : ℝ) (hc : 0 < c)
    (k : ℝ → ℤ) -- decision rule as function of net surplus
    (hk1 : ∀ s, s > 0 → k s = 1)
    (hk0 : ∀ s, s ≤ 0 → k s = 0)
    (t : Fin I → ℝ) -- transfer profile
    (ht : ∑ i : Fin I, t i = -c * ↑(k (∑ i : Fin I, θ i - c))) :
    -- The efficient outcome maximizes social surplus: Σθ_i · k - c · k ≥ Σθ_i · k' - c · k'
    -- for any alternative k' ∈ {0, 1}
    ∀ k' : ℤ, k' = 0 ∨ k' = 1 →
      (∑ i : Fin I, θ i) * ↑(k (∑ i : Fin I, θ i - c)) - c * ↑(k (∑ i : Fin I, θ i - c)) ≥
      (∑ i : Fin I, θ i) * ↑k' - c * ↑k' := by
  intro k' hk'
  set S := ∑ i : Fin I, θ i
  set d := k (S - c)
  by_cases hS : S - c > 0
  · -- S > c, so k(S-c) = 1, building is efficient
    have hd : d = 1 := hk1 _ hS
    rcases hk' with rfl | rfl
    · simp [hd]; linarith
    · simp [hd]
  · -- S ≤ c, so k(S-c) = 0, not building is efficient
    push_neg at hS
    have hd : d = 0 := hk0 _ hS
    rcases hk' with rfl | rfl
    · simp [hd]
    · simp [hd]; linarith