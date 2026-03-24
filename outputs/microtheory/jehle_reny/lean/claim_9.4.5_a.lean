import Mathlib

/-- Virtual valuation J_i(v_i) = v_i - (1 - F_i(v_i)) / f_i(v_i). -/
noncomputable def virtual_valuation (v F f : ℝ) : ℝ := v - (1 - F) / f

/-- The optimal selling mechanism is not always allocatively efficient:
    (1) the seller may retain the object when all bidders have positive values
        (when all virtual valuations are ≤ 0), and
    (2) even when the seller assigns the object, it may not go to the
        highest-value bidder (virtual valuation ordering can differ from
        value ordering across asymmetric bidders). -/
theorem Claim_9_4_5_a :
    -- Inefficiency 1: all v_i > 0 yet all J_i ≤ 0 (seller keeps object)
    (∃ v₁ v₂ F₁ F₂ f₁ f₂ : ℝ,
      v₁ > 0 ∧ v₂ > 0 ∧ f₁ > 0 ∧ f₂ > 0 ∧
      0 ≤ F₁ ∧ F₁ ≤ 1 ∧ 0 ≤ F₂ ∧ F₂ ≤ 1 ∧
      virtual_valuation v₁ F₁ f₁ ≤ 0 ∧ virtual_valuation v₂ F₂ f₂ ≤ 0) ∧
    -- Inefficiency 2: v₁ > v₂ but J₂ > J₁ (misallocation)
    (∃ v₁ v₂ F₁ F₂ f₁ f₂ : ℝ,
      v₁ > v₂ ∧ f₁ > 0 ∧ f₂ > 0 ∧
      0 ≤ F₁ ∧ F₁ ≤ 1 ∧ 0 ≤ F₂ ∧ F₂ ≤ 1 ∧
      virtual_valuation v₂ F₂ f₂ > virtual_valuation v₁ F₁ f₁) := by
  constructor
  · -- Example: v₁ = v₂ = 1, F = 0, f = 1 → J = 1 - 1/1 = 0 ≤ 0
    exact ⟨1, 1, 0, 0, 1, 1, by norm_num, by norm_num, by norm_num, by norm_num,
      by norm_num, by norm_num, by norm_num, by norm_num,
      by unfold virtual_valuation; norm_num, by unfold virtual_valuation; norm_num⟩
  · -- Example: v₁ = 2, v₂ = 1 with asymmetric distributions
    -- Bidder 1: F₁ = 0, f₁ = 1/2 → J₁ = 2 - 1/(1/2) = 0
    -- Bidder 2: F₂ = 1/2, f₂ = 2 → J₂ = 1 - (1/2)/2 = 3/4 > 0 = J₁
    exact ⟨2, 1, 0, 1 / 2, 1 / 2, 2, by norm_num, by norm_num, by norm_num,
      by norm_num, by norm_num, by norm_num, by norm_num,
      by unfold virtual_valuation; norm_num⟩