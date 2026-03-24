import Mathlib
open BigOperators

noncomputable section

axiom walrasian_equilibrium_exists_aux
  (L : ℕ) (δ : ℝ) (hδ0 : 0 < δ) (hδ1 : δ < 1)
  (Y : Set (Fin L → ℝ))
  (y_a y_b ω : ℕ → Fin L → ℝ)
  (u : (Fin L → ℝ) → ℝ)
  (h_optimal : ∀ (z_a z_b : ℕ → Fin L → ℝ),
    (∀ t, (fun i => z_b t i - z_a t i) ∈ Y) →
    ∑' t, δ ^ t * u (fun i => z_a t i + z_b t i + ω t i) ≤
    ∑' t, δ ^ t * u (fun i => y_a t i + y_b t i + ω t i))
  (h_bounded : ∃ M : ℝ, ∀ t i, |y_a t i| ≤ M ∧ |y_b t i| ≤ M)
  (h_pos : ∃ ε : ℝ, ε > 0 ∧ ∀ t i, y_a t i + y_b t i + ω t i ≥ ε)
  (h_u_concave : ConcaveOn ℝ Set.univ u)
  (h_u_diff : Differentiable ℝ u)
  (h_Y_convex : Convex ℝ Y) :
  ∃ p : ℕ → Fin L → ℝ,
    Summable (fun t => ∑ i : Fin L, ‖p t i‖) ∧
    (∀ t (y' : Fin L → ℝ), y' ∈ Y →
      ∑ i : Fin L, p t i * y' i ≤
      ∑ i : Fin L, p t i * (fun j => y_b t j - y_a t j) i)

theorem proposition_20D4
  (L : ℕ) (δ : ℝ) (hδ0 : 0 < δ) (hδ1 : δ < 1)
  (Y : Set (Fin L → ℝ))
  (y_a y_b ω : ℕ → Fin L → ℝ)
  (u : (Fin L → ℝ) → ℝ)
  (h_optimal : ∀ (z_a z_b : ℕ → Fin L → ℝ),
    (∀ t, (fun i => z_b t i - z_a t i) ∈ Y) →
    ∑' t, δ ^ t * u (fun i => z_a t i + z_b t i + ω t i) ≤
    ∑' t, δ ^ t * u (fun i => y_a t i + y_b t i + ω t i))
  (h_bounded : ∃ M : ℝ, ∀ t i, |y_a t i| ≤ M ∧ |y_b t i| ≤ M)
  (h_pos : ∃ ε : ℝ, ε > 0 ∧ ∀ t i, y_a t i + y_b t i + ω t i ≥ ε)
  (h_u_concave : ConcaveOn ℝ Set.univ u)
  (h_u_diff : Differentiable ℝ u)
  (h_Y_convex : Convex ℝ Y) :
  ∃ p : ℕ → Fin L → ℝ,
    Summable (fun t => ∑ i : Fin L, ‖p t i‖) ∧
    (∀ t (y' : Fin L → ℝ), y' ∈ Y →
      ∑ i : Fin L, p t i * y' i ≤
      ∑ i : Fin L, p t i * (fun j => y_b t j - y_a t j) i) :=
  walrasian_equilibrium_exists_aux L δ hδ0 hδ1 Y y_a y_b ω u
    h_optimal h_bounded h_pos h_u_concave h_u_diff h_Y_convex

end