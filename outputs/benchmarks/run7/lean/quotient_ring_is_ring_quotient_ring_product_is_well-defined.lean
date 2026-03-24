import Mathlib

variable {R : Type _} [CommRing R] (J : Ideal R) {x₁ x₂ y₁ y₂ : R}

theorem quotient_ring_mul_well_defined (hx : x₁ - x₂ ∈ J) (hy : y₁ - y₂ ∈ J) :
    x₁ * y₁ - x₂ * y₂ ∈ J := by
  have H : x₁ * y₁ - x₂ * y₂ = x₁ * (y₁ - y₂) + (x₁ - x₂) * y₂ := by ring
  rw [H]
  exact J.add_mem (J.mul_mem_left x₁ hy) (J.mul_mem_right y₂ hx)