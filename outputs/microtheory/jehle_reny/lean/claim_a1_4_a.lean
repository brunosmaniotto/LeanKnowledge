import Mathlib
open Topology

theorem claim_A1_4_a :
    -- (1) StrictMono implies Monotone (for ℝ → ℝ)
    (∀ f : ℝ → ℝ, StrictMono f → Monotone f) ∧
    -- (2) Monotone does not imply StrictMono
    (∃ f : ℝ → ℝ, Monotone f ∧ ¬StrictMono f) ∧
    -- (3) StrictMono does not imply strongly increasing (f y - f x > y - x)
    (∃ f : ℝ → ℝ, StrictMono f ∧ ¬∀ x y : ℝ, x < y → f y - f x > y - x) := by
  refine ⟨fun f hf => hf.monotone, ?_, ?_⟩
  · exact ⟨fun _ => (0 : ℝ), monotone_const, fun h => by
      have := h (show (0 : ℝ) < 1 by norm_num)
      simp at this⟩
  · exact ⟨id, strictMono_id, fun h => by
      have := h 0 1 (by norm_num : (0 : ℝ) < 1)
      simp [id] at this⟩