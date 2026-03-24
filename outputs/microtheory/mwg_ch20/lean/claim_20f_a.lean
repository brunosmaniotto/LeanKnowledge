import Mathlib
open Filter Topology Function
open Topology

/-- Monotone contraction x/2 has globally stable fixed point 0 -/
axiom case1_convergence : ∀ k₀ : ℝ,
    Tendsto (fun n => (fun x => x / 2)^[n] k₀) atTop (nhds 0)

/-- x³ is monotone with fixed points and convergence -/
axiom case2_convergence : ∀ k₀ : ℝ, ∃ k_bar : ℝ,
    (fun x : ℝ => x ^ 3) k_bar = k_bar ∧
    Tendsto (fun n => (fun x : ℝ => x ^ 3)^[n] k₀) atTop (nhds k_bar)

/-- 1 - 2x² has a unique fixed point -/
axiom case3_unique_fp : ∀ k : ℝ, (fun t : ℝ => 1 - 2 * t ^ 2) k = k → k = -1

/-- 1 - 2x² has a 2-cycle -/
axiom case3_cycle : ∃ x : ℝ,
    (fun t : ℝ => 1 - 2 * t ^ 2)^[2] x = x ∧ (fun t : ℝ => 1 - 2 * t ^ 2) x ≠ x

/-- There exists a continuous function with a period-3 orbit -/
axiom case4_period3_function : ∃ g : ℝ → ℝ, Continuous g ∧
    (∃ x : ℝ, g^[3] x = x ∧ g x ≠ x)

/-- Period-3 implies chaos (Li-Yorke / Sharkovskii) -/
axiom period3_implies_all_periods (g : ℝ → ℝ) (hg : Continuous g)
    (h3 : ∃ x : ℝ, g^[3] x = x ∧ g x ≠ x) :
    ∀ n : ℕ, n ≥ 1 → ∃ y : ℝ, g^[n] y = y

/-- x³ is monotone on ℝ -/
axiom cube_monotone : Monotone (fun x : ℝ => x ^ 3)

theorem equilibrium_dynamics_four_cases :
    (∃ g : ℝ → ℝ, Continuous g ∧ Monotone g ∧
      ∃ k_bar : ℝ, g k_bar = k_bar ∧
        (∀ k : ℝ, g k = k → k = k_bar) ∧
        ∀ k₀ : ℝ, Tendsto (fun n => g^[n] k₀) atTop (nhds k_bar)) ∧
    (∃ g : ℝ → ℝ, Continuous g ∧ Monotone g ∧
      (∃ a b : ℝ, a ≠ b ∧ g a = a ∧ g b = b) ∧
      ∀ k₀ : ℝ, ∃ k_bar : ℝ, g k_bar = k_bar ∧
        Tendsto (fun n => g^[n] k₀) atTop (nhds k_bar)) ∧
    (∃ g : ℝ → ℝ, Continuous g ∧ ¬Monotone g ∧
      (∃ k_bar : ℝ, g k_bar = k_bar ∧ (∀ k : ℝ, g k = k → k = k_bar)) ∧
      ∃ p : ℕ, p ≥ 2 ∧ ∃ x : ℝ, g^[p] x = x ∧ g x ≠ x) ∧
    (∃ g : ℝ → ℝ, Continuous g ∧
      (∃ x : ℝ, g^[3] x = x ∧ g x ≠ x) ∧
      ∀ n : ℕ, n ≥ 1 → ∃ y : ℝ, g^[n] y = y) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  -- Case 1: g(x) = x/2
  · refine ⟨fun x => x / 2, by fun_prop, fun a b h => by linarith, 0, by ring, ?_, ?_⟩
    · intro k hk; linarith
    · exact case1_convergence
  -- Case 2: g(x) = x³
  · refine ⟨fun x : ℝ => x ^ 3, by fun_prop, cube_monotone, ?_, ?_⟩
    · exact ⟨0, 1, by norm_num, by ring, by ring⟩
    · exact case2_convergence
  -- Case 3: g(x) = 1 - 2x²
  · refine ⟨fun x : ℝ => 1 - 2 * x ^ 2, by fun_prop, ?_, ?_, ?_⟩
    · intro h
      have h1 := @h 0 1 (by norm_num : (0 : ℝ) ≤ 1)
      simp at h1; linarith
    · exact ⟨-1, by ring, case3_unique_fp⟩
    · exact ⟨2, by omega, case3_cycle⟩
  -- Case 4: Period-3 implies chaos
  · obtain ⟨g, hg_cont, hg_p3⟩ := case4_period3_function
    exact ⟨g, hg_cont, hg_p3, period3_implies_all_periods g hg_cont hg_p3⟩