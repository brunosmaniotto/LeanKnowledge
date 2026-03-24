import Mathlib

/-- Hammond Equity (HE): society prefers utility vectors with less dispersion.
    If ū and ũ agree except on coordinates i and j, and ūᵢ < ũᵢ < ũⱼ < ūⱼ
    (ũ compresses the gap between i and j), then W(ũ) ≥ W(ū). -/
def HammondEquity {N : ℕ} (W : (Fin N → ℝ) → ℝ) : Prop :=
  ∀ (u_bar u_tilde : Fin N → ℝ) (i j : Fin N),
    i ≠ j →
    (∀ k, k ≠ i → k ≠ j → u_bar k = u_tilde k) →
    u_bar i < u_tilde i →
    u_tilde i < u_tilde j →
    u_tilde j < u_bar j →
    W u_tilde ≥ W u_bar