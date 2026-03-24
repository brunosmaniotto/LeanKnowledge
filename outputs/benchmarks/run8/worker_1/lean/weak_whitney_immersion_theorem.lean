import Mathlib

open Submodule

variable {V W : Type*} [AddCommGroup V] [Module ℝ V] [AddCommGroup W] [Module ℝ W]

/-- If the kernel of a linear map π is exactly the span of a vector a, then π x = π y if and only if
x - y is a scalar multiple of a. -/
theorem linearMap_eq_iff_sub_mem_span {π : V →ₗ[ℝ] W} {a : V}
    (hker : LinearMap.ker π = Submodule.span ℝ {a}) (x y : V) :
    π x = π y ↔ ∃ t : ℝ, x - y = t • a := by
  constructor
  · intro h
    have h' : π (x - y) = 0 := by
      rw [LinearMap.map_sub, h, sub_self]
    have h_span : x - y ∈ LinearMap.ker π := by
      rw [LinearMap.mem_ker]
      exact h'
    rw [hker] at h_span
    rcases mem_span_singleton.1 h_span with ⟨t, ht⟩
    exact ⟨t, ht.symm⟩
  · rintro ⟨t, ht⟩
    have ha_ker : a ∈ LinearMap.ker π := by
      rw [hker]
      exact mem_span_singleton_self a
    have hπa : π a = 0 := LinearMap.mem_ker.1 ha_ker
    have h_sub : π (x - y) = 0 := by
      rw [ht, LinearMap.map_smul, hπa, smul_zero]
    rw [LinearMap.map_sub, sub_eq_zero] at h_sub
    exact h_sub