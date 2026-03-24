import Mathlib
open MeasureTheory

/-- An incentive-compatible direct selling mechanism is individually rational
if and only if c̄_i(0) ≤ 0 for each bidder i. By the envelope theorem (9.5),
u_i(v) = -c̄_i(0) + ∫₀^v p̄_i(x)dx, so u_i(0) = -c̄_i(0) and u_i is
nondecreasing since p̄_i ≥ 0. -/
theorem Claim_9_4_2_a
    (I : ℕ)
    (c_bar : Fin I → ℝ → ℝ)
    (u : Fin I → ℝ → ℝ)
    -- From envelope theorem (Theorem 9.5(ii)): u_i(0) = -c̄_i(0)
    (h_at_zero : ∀ i, u i 0 = -c_bar i 0)
    -- From p̄_i ≥ 0 nondecreasing (Theorem 9.5(i)): u_i nondecreasing on [0,1]
    (h_nondecr : ∀ i v₁ v₂, 0 ≤ v₁ → v₁ ≤ v₂ → v₂ ≤ 1 → u i v₁ ≤ u i v₂) :
    (∀ i, ∀ v ∈ Set.Icc (0 : ℝ) 1, 0 ≤ u i v) ↔ (∀ i, c_bar i 0 ≤ 0) := by
  constructor
  · -- IR ⟹ c̄_i(0) ≤ 0: evaluate at v = 0
    intro h_ir i
    have h0 := h_ir i 0 ⟨le_refl 0, zero_le_one⟩
    rw [h_at_zero i] at h0
    linarith
  · -- c̄_i(0) ≤ 0 ⟹ IR: u(0) = -c̄(0) ≥ 0 and u nondecreasing
    intro h_cost i v hv
    have h0 : 0 ≤ u i 0 := by rw [h_at_zero i]; linarith [h_cost i]
    linarith [h_nondecr i 0 v (le_refl 0) hv.1 hv.2]