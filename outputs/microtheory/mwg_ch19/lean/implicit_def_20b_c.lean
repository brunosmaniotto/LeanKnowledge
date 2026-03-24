import Mathlib

/-- Preferences over consumption streams satisfy stationarity if for any two streams
    c ≠ c' that agree up to period T-1, the ranking V(c) ≥ V(c') holds iff
    V(c^T) ≥ V(c'^T), where c^T is the stream shifted by T periods. -/
def StationaryPreferences (V : (ℕ → ℝ) → ℝ) : Prop :=
  ∀ (c c' : ℕ → ℝ), c ≠ c' →
    ∀ (T : ℕ), (∀ t, t < T → c t = c' t) →
      (V c ≥ V c' ↔ V (fun t => c (t + T)) ≥ V (fun t => c' (t + T)))