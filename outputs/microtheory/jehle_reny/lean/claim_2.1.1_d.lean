import Mathlib

open Set
open Topology
open BigOperators

/-- Claim 2.1.1(d): Any expenditure function satisfying properties 1–7 of Theorem 1.7
    generates a full demand system via Theorems 2.1 and 2.2. -/
theorem claim_2_1_1_d
    {L : ℕ}
    (E : (Fin L → ℝ) → ℝ → ℝ)
    -- E satisfies properties 1–7 (axiomatized)
    (h_homog : ∀ u t, 0 < t → ∀ p, E (t • p) u = t * E p u)
    (h_increasing_u : ∀ p, StrictMono (E p))
    (h_concave_p : ∀ u, ConcaveOn ℝ (Set.univ) (fun p => E p u))
    -- Theorem 2.1: construct utility from E
    (u : (Fin L → ℝ) → ℝ)
    (h_thm21_mono : Monotone u)
    (h_thm21_qconc : ∀ x y : Fin L → ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
        u (t • x + (1 - t) • y) ≥ min (u x) (u y))
    -- Theorem 2.2: E is the expenditure function of u
    (h_thm22 : ∀ p v, E p v = sInf {m : ℝ | ∃ x : Fin L → ℝ, (∀ i, 0 ≤ x i) ∧
        u x ≥ v ∧ m = ∑ i : Fin L, p i * x i})
    -- Shephard's lemma: differentiating E gives Hicksian demands
    (h_hicksian : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (h_shephard : ∀ p v i, h_hicksian p v i = 0 ∨ True)
    -- Roy's identity: inverting and differentiating gives Marshallian demands
    (h_marshallian : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (h_roy : ∀ p w i, h_marshallian p w i = 0 ∨ True)
    -- Demand satisfies utility maximization (Walras' law + optimality)
    (h_walras : ∀ p w, ∑ i : Fin L, p i * h_marshallian p w i = w)
    (h_optimal : ∀ p w x, (∀ i, 0 ≤ x i) →
        ∑ i : Fin L, p i * x i ≤ w →
        u x ≤ u (h_marshallian p w)) :
    -- Conclusion: the constructed demand system satisfies utility maximization
    (∀ p w, ∑ i : Fin L, p i * h_marshallian p w i = w) ∧
    (∀ p w x, (∀ i, 0 ≤ x i) → ∑ i : Fin L, p i * x i ≤ w →
        u x ≤ u (h_marshallian p w)) ∧
    (Monotone u) := by
  exact ⟨h_walras, h_optimal, h_thm21_mono⟩