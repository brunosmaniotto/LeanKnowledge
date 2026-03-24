import Mathlib
open Finset BigOperators
open Topology
open BigOperators

theorem Theorem_3_2_P7
    {n : ℕ}
    (c : (Fin n → ℝ) → ℝ → ℝ)
    (x : (Fin n → ℝ) → ℝ → Fin n → ℝ)
    (w₀ : Fin n → ℝ) (y₀ : ℝ)
    (hcost : ∀ w, c w y₀ = ∑ i : Fin n, w i * x w y₀ i)
    (Dx : Fin n → (Fin n → ℝ) →L[ℝ] ℝ)
    (hx_diff : ∀ i, HasFDerivAt (fun w => x w y₀ i) (Dx i) w₀)
    (henvelope : ∑ i, w₀ i • Dx i = 0) :
    HasFDerivAt (fun w => c w y₀)
      (∑ i, x w₀ y₀ i • (ContinuousLinearMap.proj i : (Fin n → ℝ) →L[ℝ] ℝ)) w₀ := by
  simp_rw [hcost]
  have hmul : ∀ i ∈ (univ : Finset (Fin n)),
      HasFDerivAt (fun w => w i * x w y₀ i)
        (w₀ i • Dx i + x w₀ y₀ i • (ContinuousLinearMap.proj i : (Fin n → ℝ) →L[ℝ] ℝ)) w₀ :=
    fun i _ => (ContinuousLinearMap.proj i : (Fin n → ℝ) →L[ℝ] ℝ).hasFDerivAt.mul (hx_diff i)
  have hsum := HasFDerivAt.sum hmul
  rw [Finset.sum_add_distrib, henvelope, zero_add] at hsum
  have hfn : (fun (w : Fin n → ℝ) => ∑ i : Fin n, w i * x w y₀ i) =
      (∑ i : Fin n, fun (w : Fin n → ℝ) => w i * x w y₀ i) := by
    ext w; simp [Finset.sum_apply]
  rw [hfn]; exact hsum