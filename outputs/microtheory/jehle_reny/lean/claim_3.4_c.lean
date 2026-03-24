import Mathlib

open BigOperators Finset
open Topology

variable {n : ℕ}

/-- Conditional input demands are consistent with cost minimization iff
    there exists a cost function c with c(w,y) = w·x(w,y) and
    c(w',y) ≤ w'·x(w,y) for all w' (the envelope/Shephard condition). -/
theorem Claim_3_4_c (x : (Fin n → ℝ) → ℝ → Fin n → ℝ) :
    (∃ V : ℝ → Set (Fin n → ℝ),
      ∀ w y, x w y ∈ V y ∧ ∀ z ∈ V y, ∑ i, w i * (x w y) i ≤ ∑ i, w i * z i) ↔
    (∃ c : (Fin n → ℝ) → ℝ → ℝ,
      (∀ w y, c w y = ∑ i, w i * (x w y) i) ∧
      (∀ w w' y, c w' y ≤ ∑ i, w' i * (x w y) i)) := by
  constructor
  · rintro ⟨V, hV⟩
    exact ⟨fun w y => ∑ i, w i * (x w y) i, fun _ _ => rfl, fun w w' y =>
      (hV w' y).2 (x w y) (hV w y).1⟩
  · rintro ⟨c, hc_eq, hc_le⟩
    refine ⟨fun y => {z | ∀ w', c w' y ≤ ∑ i, w' i * z i}, fun w y => ⟨?_, ?_⟩⟩
    · intro w'
      exact hc_le w w' y
    · intro z hz
      exact (hc_eq w y).symm.le.trans (hz w)