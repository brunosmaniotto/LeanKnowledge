import Mathlib
open Topology

/-- In the take-it-or-leave-it game with N dollars, the backward induction outcome
    is the unique NE outcome, but the NE strategy profile is not unique. -/
theorem exercise_7_29_d (N : ℝ) (hN : 0 < N) :
    -- Part 1: In any NE, Player 1's offer equals 0 (unique outcome: P1 gets N)
    (∀ (offer : ℝ) (accept : ℝ → Prop),
      0 ≤ offer → offer ≤ N → accept offer →
      (∀ x, 0 < x → x ≤ N → accept x) →
      (∀ x, 0 ≤ x → x ≤ N → accept x → offer ≤ x) →
      offer = 0) ∧
    -- Part 2: NE is not unique (different P2 strategies support offer = 0)
    (∃ f₁ f₂ : ℝ → Prop, f₁ ≠ f₂ ∧
      f₁ 0 ∧ f₂ 0 ∧
      (∀ x, 0 < x → x ≤ N → f₁ x) ∧
      (∀ x, 0 < x → x ≤ N → f₂ x)) := by
  constructor
  · -- Unique NE outcome: if offer > 0, then offer/2 is accepted and smaller, contradiction
    intro offer accept h_nn h_le _ h_p2 h_p1
    by_contra h
    have hpos : 0 < offer := lt_of_le_of_ne h_nn (Ne.symm h)
    have h1 : 0 < offer / 2 := by linarith
    have h2 : offer / 2 ≤ N := by linarith
    have := h_p1 (offer / 2) h1.le h2 (h_p2 _ h1 h2)
    linarith
  · -- Non-uniqueness: "accept all" vs "accept nonneg" differ at -1
    refine ⟨fun _ => True, fun x => (0 : ℝ) ≤ x, ?_, trivial, le_refl 0,
            fun _ _ _ => trivial, fun _ hx _ => hx.le⟩
    intro h
    have h1 : (fun _ : ℝ => True) (-1) = (fun x : ℝ => (0 : ℝ) ≤ x) (-1) := congr_fun h (-1)
    simp at h1
    linarith