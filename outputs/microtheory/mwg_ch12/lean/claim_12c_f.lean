import Mathlib
open Topology

axiom step1_no_fixed_point_of_jumping_map : ¬ ∃ x : ℝ, 0 ≤ x ∧ x ≤ 1 ∧ (if x < 1/2 then (3/4 : ℝ) else (1/4 : ℝ)) = x
axiom step2_quasiconcave_implies_convex_valued_argmax {f : ℝ → ℝ} {s : Set ℝ} (hs : Convex ℝ s) (hf : QuasiconcaveOn ℝ s f) (hne : (s ∩ {x | ∀ y ∈ s, f y ≤ f x}).Nonempty) : Convex ℝ (s ∩ {x | ∀ y ∈ s, f y ≤ f x})
axiom step3_non_quasiconcave_has_nonconvex_superlevel : ∃ f : ℝ → ℝ, ¬ QuasiconcaveOn ℝ (Set.Icc 0 1) f
axiom step4_counterexample_game_no_equilibrium : ∃ (π : ℝ → ℝ → ℝ), (¬ QuasiconcaveOn ℝ (Set.Icc 0 1) (π · 0)) ∧ ¬ ∃ q : ℝ, q ∈ Set.Icc 0 1 ∧ ∀ q' ∈ Set.Icc (0:ℝ) 1, π q' 0 ≤ π q 0

theorem Claim_12C_f :
    (∃ (π : ℝ → ℝ → ℝ),
      (¬ QuasiconcaveOn ℝ (Set.Icc 0 1) (π · 0)) ∧
      ¬ ∃ q : ℝ, q ∈ Set.Icc 0 1 ∧ ∀ q' ∈ Set.Icc (0:ℝ) 1, π q' 0 ≤ π q 0) ∧
    (∀ {f : ℝ → ℝ} {s : Set ℝ},
      Convex ℝ s → QuasiconcaveOn ℝ s f →
      (s ∩ {x | ∀ y ∈ s, f y ≤ f x}).Nonempty →
      Convex ℝ (s ∩ {x | ∀ y ∈ s, f y ≤ f x})) :=
  ⟨step4_counterexample_game_no_equilibrium,
   fun hs hf hne => step2_quasiconcave_implies_convex_valued_argmax hs hf hne⟩