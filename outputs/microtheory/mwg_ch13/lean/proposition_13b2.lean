import Mathlib

theorem Proposition_13B2
    (r condExp F : ℝ → ℝ)
    (θl θu θs : ℝ)
    (h_int : θl < θu)
    (θs_mem : θs ∈ Set.Icc θl θu)
    (r_strict_mono : StrictMono r)
    (r_below : ∀ θ, θ ∈ Set.Icc θl θu → r θ < θ)
    (F_pos : ∀ θ, θ ∈ Set.Ioc θl θu → 0 < F θ)
    (F_le_one : ∀ θ, θ ∈ Set.Icc θl θu → F θ ≤ 1)
    (F_lt_one : ∀ θ, θ ∈ Set.Ico θl θu → F θ < 1)
    (equil : r θs = condExp θs)
    (prop_13B1 : ∀ t, t ∈ Set.Ioc θs θu → condExp t < r t)
    (condExp_mono : ∀ a b, a ∈ Set.Icc θl θu → b ∈ Set.Icc θl θu →
      a ≤ b → condExp a ≤ condExp b)
    : (∀ t, t ∈ Set.Ioc θs θu → F t * (condExp t - r t) < 0)
      ∧
      (∀ t, t ∈ Set.Ico θl θs → θl < t →
        F t * (condExp t - r t) + r t < r θs) := by
  constructor
  · intro t ht
    have hcond : condExp t < r t := prop_13B1 t ht
    have hF : 0 < F t := F_pos t ⟨lt_of_le_of_lt θs_mem.1 ht.1, ht.2⟩
    exact mul_neg_of_pos_of_neg hF (by linarith)
  · intro t ht ht_pos
    have ht_lt : t < θs := ht.2
    have ht_le : t ≤ θs := le_of_lt ht_lt
    have ht_cc : t ∈ Set.Icc θl θu := ⟨ht.1, le_trans ht_le θs_mem.2⟩
    have hcE_le : condExp t ≤ condExp θs := condExp_mono t θs ht_cc θs_mem ht_le
    have hcE_le_r : condExp t ≤ r θs := by
      have : condExp θs = r θs := equil.symm
      linarith
    have hF_nn : 0 ≤ F t := le_of_lt (F_pos t ⟨ht_pos, le_trans ht_le θs_mem.2⟩)
    have hr_lt : r t < r θs := r_strict_mono ht_lt
    have hF_lt : F t < 1 := F_lt_one t ⟨ht.1, lt_of_lt_of_le ht_lt θs_mem.2⟩
    have h1 : F t * (condExp t - r θs) ≤ 0 :=
      mul_nonpos_of_nonneg_of_nonpos hF_nn (by linarith)
    have h2 : (1 - F t) * (r t - r θs) < 0 :=
      mul_neg_of_pos_of_neg (by linarith) (by linarith)
    have key : F t * (condExp t - r t) + r t - r θs =
      F t * (condExp t - r θs) + (1 - F t) * (r t - r θs) := by ring
    linarith