import Mathlib

open Topology

/-- In a separating equilibrium where equilibrium policies are accepted,
    the high-risk consumer's policy must be full insurance at the
    actuarially fair premium: ψ_h = (L, π̄L). -/
theorem Claim_8_1_converse_1
    (u : ℝ → ℝ → ℝ)
    (B_h p_h L π_bar π_bar_L : ℝ)
    -- π̄L is the actuarially fair premium for full coverage L
    (h_fair : π_bar_L = π_bar * L)
    -- Lemma 8.1: equilibrium utility ≥ utility at full insurance
    (h_lemma81 : u B_h p_h ≥ u L π_bar_L)
    -- Acceptance requires non-negative profits: p_h ≥ π̄ · B_h
    (h_profit : p_h ≥ π_bar * B_h)
    -- Utility is antitone in premium (higher premium → lower utility)
    (h_antitone_p : ∀ B p₁ p₂, p₁ ≤ p₂ → u B p₂ ≤ u B p₁)
    -- Along the zero-profit line p = π̄B, full insurance maximizes utility
    (h_full_ins : ∀ B, u B (π_bar * B) ≤ u L (π_bar * L))
    -- Equality on zero-profit line only at B = L
    (h_unique : ∀ B, u B (π_bar * B) = u L (π_bar * L) → B = L)
    -- At fixed B = L, u(L, p) ≥ u(L, π̄L) implies p ≤ π̄L
    (h_strict_p : ∀ p, u L p ≥ u L π_bar_L → p ≤ π_bar_L)
    : B_h = L ∧ p_h = π_bar_L := by
  -- Since p_h ≥ π̄·B_h and u is antitone in premium
  have anti : u B_h p_h ≤ u B_h (π_bar * B_h) :=
    h_antitone_p B_h (π_bar * B_h) p_h h_profit
  -- Along zero-profit line, utility ≥ utility at (L, π̄L)
  have along : u L (π_bar * L) ≤ u B_h (π_bar * B_h) := by
    have h1 : u L π_bar_L ≤ u B_h p_h := h_lemma81
    rw [h_fair] at h1
    linarith
  -- Combined with optimality on zero-profit line: equality, so B_h = L
  have eq_line : u B_h (π_bar * B_h) = u L (π_bar * L) :=
    le_antisymm (h_full_ins B_h) along
  have hB : B_h = L := h_unique B_h eq_line
  refine ⟨hB, ?_⟩
  -- From profit condition: p_h ≥ π̄L
  have hp_ge : p_h ≥ π_bar * L := by rw [← hB]; exact h_profit
  -- From Lemma 8.1 with B_h = L: u(L, p_h) ≥ u(L, π̄L), so p_h ≤ π̄L
  rw [hB] at h_lemma81
  have hp_le : p_h ≤ π_bar_L := h_strict_p p_h h_lemma81
  linarith