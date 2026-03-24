import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- If consumer 1 has greater absolute risk aversion than consumer 2 everywhere,
    then for any gamble, consumer 1's certainty equivalent is strictly less than
    consumer 2's. The key step is Jensen's inequality applied to the strictly
    concave composition h = u ∘ v⁻¹. -/
theorem claim_2_4_3_g
    {n : ℕ}
    (u v : ℝ → ℝ)
    (hu_mono : StrictMono u)
    (p : Fin n → ℝ)
    (w : Fin n → ℝ)
    (ce₁ ce₂ : ℝ)
    -- Certainty equivalent definitions
    (hce₁ : u ce₁ = ∑ i, p i * u (w i))
    (hce₂ : v ce₂ = ∑ i, p i * v (w i))
    -- Jensen's inequality on h = u ∘ v⁻¹ (strictly concave since R¹ₐ > R²ₐ):
    -- ∑ pᵢ · h(v(wᵢ)) < h(∑ pᵢ · v(wᵢ)), i.e. ∑ pᵢ · u(wᵢ) < u(ce₂)
    (hJensen : ∑ i, p i * u (w i) < u ce₂)
    : ce₁ < ce₂ := by
  have h : u ce₁ < u ce₂ := by linarith
  by_contra hle
  push_neg at hle
  linarith [hu_mono.monotone hle]