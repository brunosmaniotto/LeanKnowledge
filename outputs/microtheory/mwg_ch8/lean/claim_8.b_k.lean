import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {S : Type*} [Fintype S] [DecidableEq S]

noncomputable def expUtil' (u : S → ℝ) (σ : S → ℝ) : ℝ :=
  ∑ s : S, σ s * u s

theorem strictly_dominated_mixed
    (si : S)
    (σ_dom : S → ℝ)
    (hσ_dom_nonneg : ∀ s, 0 ≤ σ_dom s)
    (hσ_dom_sum : ∑ s, σ_dom s = 1)
    (τ : S → ℝ)
    (hτ_nonneg : ∀ s, 0 ≤ τ s)
    (hτ_sum : ∑ s, τ s = 1)
    (hτ_pos : τ si > 0)
    (h_dom : ∀ u : S → ℝ, expUtil' u σ_dom > u si)
    : ∀ u : S → ℝ,
        expUtil' u (fun s => τ s + τ si * (σ_dom s - if s = si then 1 else 0)) >
        expUtil' u τ := by
  intro u
  simp only [expUtil']
  suffices key : ∑ s : S, (τ s + τ si * (σ_dom s - if s = si then 1 else 0)) * u s -
      ∑ s : S, τ s * u s = τ si * (∑ s : S, σ_dom s * u s - u si) by
    have h1 := h_dom u; simp only [expUtil'] at h1; nlinarith
  rw [← Finset.sum_sub_distrib]
  have hsub : ∀ s : S, (τ s + τ si * (σ_dom s - if s = si then 1 else 0)) * u s - τ s * u s
      = τ si * ((σ_dom s - if s = si then 1 else 0) * u s) := fun s => by ring
  simp_rw [hsub]
  rw [← Finset.mul_sum]
  congr 1
  simp_rw [sub_mul]
  rw [Finset.sum_sub_distrib]
  have : ∑ s : S, (if s = si then (1 : ℝ) else 0) * u s = u si := by
    simp [Finset.sum_ite_eq', Finset.mem_univ]
  linarith