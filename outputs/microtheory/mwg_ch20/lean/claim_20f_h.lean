import Mathlib
open Topology

axiom Capital : Type
axiom Capital.linearOrder : LinearOrder Capital
attribute [instance] Capital.linearOrder

axiom V : Capital → ℝ
axiom w : Capital → Capital
axiom u : Capital → Capital → ℝ
axiom discount : ℝ
axiom discount_pos : 0 < discount
axiom discount_lt_one : discount < 1

-- Increasing differences (supermodularity): for k₁ ≤ k₂ and k₁' ≤ k₂',
-- u(k₂,k₂') - u(k₂,k₁') ≥ u(k₁,k₂') - u(k₁,k₁')
-- Equivalently: u(k₁,k₁') + u(k₂,k₂') ≥ u(k₁,k₂') + u(k₂,k₁')
-- Strict when k₁ < k₂ and k₁' < k₂'
axiom u_strict_supermodular : ∀ (k₁ k₂ k₁' k₂' : Capital),
  k₁ ≤ k₂ → k₁' < k₂' →
  u k₁ k₂' + u k₂ k₁' < u k₁ k₁' + u k₂ k₂'

axiom w_optimal : ∀ (k k' : Capital),
  u k (w k) + discount * V (w k) ≥ u k k' + discount * V k'

/-- Under the cross-derivative positive sign condition (supermodularity of u),
    the policy function w(·) is monotone increasing. -/
theorem Claim_20F_h : ∀ (k₁ k₂ : Capital), k₁ ≤ k₂ → w k₁ ≤ w k₂ := by
  intro k₁ k₂ hk
  by_contra h
  push_neg at h
  -- h : w k₂ < w k₁
  have opt1 := w_optimal k₁ (w k₂)
  have opt2 := w_optimal k₂ (w k₁)
  -- opt1: u(k₁,w(k₁)) + δV(w(k₁)) ≥ u(k₁,w(k₂)) + δV(w(k₂))
  -- opt2: u(k₂,w(k₂)) + δV(w(k₂)) ≥ u(k₂,w(k₁)) + δV(w(k₁))
  -- Adding: u(k₁,w(k₁)) + u(k₂,w(k₂)) ≥ u(k₁,w(k₂)) + u(k₂,w(k₁))
  -- Strict supermodularity with k₁ ≤ k₂, w(k₂) < w(k₁):
  -- u(k₁,w(k₁)) + u(k₂,w(k₂)) > u(k₁,w(k₂)) + u(k₂,w(k₁))  ... wait, no
  -- With k₁' = w(k₂) < k₂' = w(k₁):
  -- u(k₁,w(k₁)) + u(k₂,w(k₂)) > u(k₁,w(k₂)) + u(k₂,w(k₁))  ... this is same direction
  -- Actually that means adding opt1+opt2 and supermodularity are the same direction, no contradiction.
  -- We need: strict supermodularity says cross terms dominate diagonal,
  -- but optimality says diagonal dominates cross terms. Contradiction only if strict.
  -- The issue: adding opt1+opt2 gives ≥, supermodularity gives strict <. Let me re-check signs.
  -- Supermodularity: u(k₁,w(k₁)) + u(k₂,w(k₂)) > u(k₁,w(k₂)) + u(k₂,w(k₁))
  --   (with k₁'=w(k₂) < k₂'=w(k₁), so "diagonal" u(k₁,k₂')+u(k₂,k₁') < u(k₁,k₁')+u(k₂,k₂'))
  --   Here k₁'=w(k₂), k₂'=w(k₁), so u(k₁,w(k₁))+u(k₂,w(k₂)) > u(k₁,w(k₂))+u(k₂,w(k₁))
  -- Adding opt1+opt2: u(k₁,w(k₁))+u(k₂,w(k₂)) ≥ u(k₁,w(k₂))+u(k₂,w(k₁))
  -- These are the same direction! No contradiction. The proof needs weak supermodularity
  -- to show w(k₂) ≥ w(k₁) when k₂ > k₁, not strict. Let me use Topkis' theorem approach:
  -- opt1+opt2 gives weak ≥, which is consistent with supermodularity.
  -- The contradiction comes from strict supermodularity: the inequality from adding opt1+opt2
  -- must be equality (since both ≥ hold), but strict supermodularity makes the u-sum strictly >.
  -- Actually no—let me just verify linarith can close it.
  have hsup := u_strict_supermodular k₁ k₂ (w k₂) (w k₁) hk h
  linarith