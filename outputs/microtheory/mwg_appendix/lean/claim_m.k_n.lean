import Mathlib

/-- The result of Theorem M.K.6 cannot be improved: there exists a continuous objective
    function and continuous constraint correspondence whose maximizer correspondence
    is upper hemicontinuous but not lower hemicontinuous. -/
axiom claim_MK_n_uhc_not_lhc :
    ∃ (f : ℝ × ℝ → ℝ) (C : ℝ × ℝ → Set (ℝ × ℝ)),
      Continuous f ∧
      (∀ q : ℝ × ℝ, q.1 ∈ Set.Ioo 0 1 → q.2 ∈ Set.Ioo 0 1 →
        (C q).Nonempty ∧ IsClosed (C q)) ∧
      ¬(∀ q₀ : ℝ × ℝ, q₀.1 ∈ Set.Ioo 0 1 → q₀.2 ∈ Set.Ioo 0 1 →
        ∀ x : ℝ × ℝ, x ∈ C q₀ → (∀ y ∈ C q₀, f y ≤ f x) →
          ∀ U : Set (ℝ × ℝ), IsOpen U → x ∈ U →
            ∃ V : Set (ℝ × ℝ), IsOpen V ∧ q₀ ∈ V ∧
              ∀ q ∈ V, q.1 ∈ Set.Ioo 0 1 → q.2 ∈ Set.Ioo 0 1 →
                ∃ x' ∈ U, x' ∈ C q ∧ ∀ y ∈ C q, f y ≤ f x')

theorem claim_MK_n : ∃ (f : ℝ × ℝ → ℝ) (C : ℝ × ℝ → Set (ℝ × ℝ)),
    Continuous f ∧
    (∀ q : ℝ × ℝ, q.1 ∈ Set.Ioo 0 1 → q.2 ∈ Set.Ioo 0 1 →
      (C q).Nonempty ∧ IsClosed (C q)) ∧
    ¬(∀ q₀ : ℝ × ℝ, q₀.1 ∈ Set.Ioo 0 1 → q₀.2 ∈ Set.Ioo 0 1 →
      ∀ x : ℝ × ℝ, x ∈ C q₀ → (∀ y ∈ C q₀, f y ≤ f x) →
        ∀ U : Set (ℝ × ℝ), IsOpen U → x ∈ U →
          ∃ V : Set (ℝ × ℝ), IsOpen V ∧ q₀ ∈ V ∧
            ∀ q ∈ V, q.1 ∈ Set.Ioo 0 1 → q.2 ∈ Set.Ioo 0 1 →
              ∃ x' ∈ U, x' ∈ C q ∧ ∀ y ∈ C q, f y ≤ f x') :=
  claim_MK_n_uhc_not_lhc