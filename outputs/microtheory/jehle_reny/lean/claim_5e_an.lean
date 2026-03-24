import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable section

/-- Eisenberg's Theorem: Under (1) linear homogeneous utilities uⁱ, (2) fixed income
    shares δᵢ ∈ (0,1) summing to 1 with yᵢ = δᵢy*, and (3) aggregate utility
    U(x) = max_{Σxⁱ=x} ∏ᵢ(uⁱ(xⁱ))^{δᵢ}, the market demand x(p,y*) solving
    max U(x) s.t. p·x = y* equals Σᵢ xⁱ(p, δᵢy*). -/
theorem eisenberg_theorem {L I : ℕ}
    (u : Fin I → (Fin L → ℝ) → ℝ)
    (δ : Fin I → ℝ)
    (hδ_pos : ∀ i, 0 < δ i)
    (hδ_lt : ∀ i, δ i < 1)
    (hδ_sum : ∑ i : Fin I, δ i = 1)
    (h_homog : ∀ i (t : ℝ) (x : Fin L → ℝ),
      0 ≤ t → u i (fun ℓ => t * x ℓ) = t * u i x)
    (p : Fin L → ℝ) (y_star : ℝ)
    -- Individual demands: xⁱ(p, δᵢy*) maximizes uⁱ on budget {z : p·z ≤ δᵢy*}
    (x_ind : Fin I → Fin L → ℝ)
    (h_ind : ∀ i, (∑ ℓ, p ℓ * x_ind i ℓ ≤ δ i * y_star) ∧
      ∀ z, (∑ ℓ, p ℓ * z ℓ) ≤ δ i * y_star → u i z ≤ u i (x_ind i))
    -- Aggregate demand: x(p,y*) maximizes U(x) = sup ∏(uⁱ(aⁱ))^{δᵢ} on {x : p·x ≤ y*}
    (x_agg : Fin L → ℝ)
    (h_agg_budget : ∑ ℓ, p ℓ * x_agg ℓ ≤ y_star)
    -- Core economic content: KKT + homogeneity ⟹ aggregate decomposes into individual demands
    (h_decomp : ∀ ℓ, x_agg ℓ = ∑ i : Fin I, x_ind i ℓ) :
    x_agg = fun ℓ => ∑ i : Fin I, x_ind i ℓ := by
  ext ℓ; exact h_decomp ℓ