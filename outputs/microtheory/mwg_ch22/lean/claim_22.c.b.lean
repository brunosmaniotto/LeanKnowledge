import Mathlib

theorem claim_22_C_b
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (W : (ι → ℝ) → ℝ)
    (hW_sym : ∀ (σ : Equiv.Perm ι) (u : ι → ℝ), W (u ∘ σ) = W u)
    (grad : (ι → ℝ) → ι → ℝ)
    (hgrad : ∀ (σ : Equiv.Perm ι) (u : ι → ℝ) (i : ι),
      grad (u ∘ σ) (σ i) = grad u i)
    (u : ι → ℝ) (c : ℝ) (hu : u = Function.const ι c)
    (i j : ι) :
    grad u i = grad u j := by
  have hconst : ∀ σ : Equiv.Perm ι, u ∘ σ = u := by
    intro σ; subst hu; ext k; simp [Function.const]
  let σ := Equiv.swap i j
  have h1 : grad (u ∘ σ) (σ i) = grad u i := hgrad σ u i
  rw [hconst σ] at h1
  -- h1 : grad u (σ i) = grad u i
  have h2 : σ i = j := Equiv.swap_apply_left i j
  rw [h2] at h1
  -- h1 : grad u j = grad u i
  exact h1.symm