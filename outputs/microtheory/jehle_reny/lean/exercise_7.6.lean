import Mathlib
open Topology

/-- Any strategy surviving iterative weak dominance also survives iterative
    strict dominance. Strict domination implies weak domination, and domination
    is anti-monotone in the strategy set (fewer opponents ⇒ easier to dominate),
    so weak-dominance elimination removes at least as many strategies each round. -/
theorem iterative_weak_dominance_survives_strict
    {S : Type*}
    (weak_dom strict_dom : Set S → S → Prop)
    (h_strict_implies_weak : ∀ R s, strict_dom R s → weak_dom R s)
    (h_anti_mono_strict : ∀ R₁ R₂ s, R₁ ⊆ R₂ → strict_dom R₂ s → strict_dom R₁ s)
    (iter_weak iter_strict : ℕ → Set S)
    (h_init_weak : iter_weak 0 = Set.univ)
    (h_init_strict : iter_strict 0 = Set.univ)
    (h_step_weak : ∀ n, iter_weak (n + 1) = {s ∈ iter_weak n | ¬ weak_dom (iter_weak n) s})
    (h_step_strict : ∀ n, iter_strict (n + 1) = {s ∈ iter_strict n | ¬ strict_dom (iter_strict n) s})
    : ∀ n, iter_weak n ⊆ iter_strict n := by
  intro n
  induction n with
  | zero => simp [h_init_weak, h_init_strict]
  | succ n ih =>
    intro s
    simp only [h_step_weak, h_step_strict, Set.mem_sep_iff]
    exact fun ⟨hw, hnw⟩ =>
      ⟨ih hw, fun hs => hnw (h_strict_implies_weak _ _ (h_anti_mono_strict _ _ _ ih hs))⟩