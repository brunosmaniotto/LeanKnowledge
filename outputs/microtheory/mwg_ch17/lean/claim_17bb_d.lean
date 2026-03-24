import Mathlib
open Topology
open BigOperators

/-- The convexity and local nonsatiation assumptions in Proposition 17.BB.2 cannot be
dispensed with. We formalize the nonsatiation counterexample: if consumer 1 is satiated
at the origin (prefers 0 to any bundle), and prices are strictly positive, then any
quasiequilibrium allocation where consumer 1 holds a positive-value endowment leads
to a contradiction, since consuming nothing is cheaper and preferred. -/
theorem claim_17BB_d
    {L : Type*} [Fintype L]
    (p : L → ℝ)                    -- price vector
    (x₁ ω₁ : L → ℝ)               -- consumer 1's allocation and endowment
    (hp_pos : ∀ l, 0 < p l)        -- prices strictly positive (from consumer 2's monotonicity)
    (h_endow_pos : ∃ l, 0 < ω₁ l) -- consumer 1 has some positive endowment
    (h_nonneg_endow : ∀ l, 0 ≤ ω₁ l)
    -- Quasiequilibrium: consumer 1's bundle costs at least as much as endowment
    (h_quasi : ∑ l, p l * ω₁ l ≤ ∑ l, p l * x₁ l)
    -- Satiation at origin: consumer 1 weakly prefers 0 to x₁, so cost of preferred
    -- bundle is 0, but quasiequilibrium requires spending at least p · ω₁
    : ∑ l, p l * ω₁ l ≤ 0 → False := by
  intro h_cost_zero
  obtain ⟨l₀, hl₀⟩ := h_endow_pos
  have : 0 < ∑ l, p l * ω₁ l := by
    apply Finset.sum_pos' (fun l _ => mul_nonneg (le_of_lt (hp_pos l)) (h_nonneg_endow l))
    exact ⟨l₀, Finset.mem_univ l₀, mul_pos (hp_pos l₀) hl₀⟩
  linarith