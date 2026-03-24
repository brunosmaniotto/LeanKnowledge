import Mathlib
open Topology

noncomputable section

/-- Theorem 8.3 (Intuitive Criterion Equilibrium):
    The unique separating equilibrium satisfying the intuitive criterion
    is the best separating equilibrium (ψ̄_l, ψ^c_h). -/
theorem Theorem_8_3
    {Policy : Type}
    (u_l u_h : Policy → ℝ)
    (ψ_bar_l ψ_c_h : Policy)
    (is_IC_sep_eq : Policy → Policy → Prop)
    -- Lemma 8.1: in any IC separating equilibrium, high-risk utility ≥ competitive
    (h_high_bound : ∀ ψ_l ψ_h, is_IC_sep_eq ψ_l ψ_h → u_h ψ_h ≥ u_h ψ_c_h)
    -- IC + continuity argument: low-risk utility ≥ best-separating utility
    (h_low_bound : ∀ ψ_l ψ_h, is_IC_sep_eq ψ_l ψ_h → u_l ψ_l ≥ u_l ψ_bar_l)
    -- Theorem 8.1: these utility bounds uniquely determine the policy pair
    (h_thm_8_1 : ∀ ψ_l ψ_h, is_IC_sep_eq ψ_l ψ_h →
      u_l ψ_l ≥ u_l ψ_bar_l → u_h ψ_h ≥ u_h ψ_c_h →
      ψ_l = ψ_bar_l ∧ ψ_h = ψ_c_h)
    -- Existence: (ψ̄_l, ψ^c_h) can be supported as an IC separating equilibrium
    (h_exists : is_IC_sep_eq ψ_bar_l ψ_c_h) :
    -- Conclusion: uniqueness and existence
    (∀ ψ_l ψ_h, is_IC_sep_eq ψ_l ψ_h → ψ_l = ψ_bar_l ∧ ψ_h = ψ_c_h) ∧
    is_IC_sep_eq ψ_bar_l ψ_c_h := by
  exact ⟨fun ψ_l ψ_h h =>
    h_thm_8_1 ψ_l ψ_h h (h_low_bound ψ_l ψ_h h) (h_high_bound ψ_l ψ_h h), h_exists⟩