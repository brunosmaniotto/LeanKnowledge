import Mathlib

theorem revelation_principle_binary_mechanism
    {θ : Type*} [Nonempty θ]
    (l : θ → Bool) (w : θ → ℝ)
    (ic_equal : ∀ a b : θ, l a = l b → w a = w b) :
    ∃ (w_e w_u : ℝ), ∀ x : θ,
      (l x = true → w x = w_e) ∧ (l x = false → w x = w_u) := by
  obtain ⟨x₀⟩ := ‹Nonempty θ›
  by_cases h₀ : l x₀ = true
  · -- x₀ has l = true; need a representative for l = false
    by_cases hex : ∃ y, l y = false
    · obtain ⟨y₀, hy₀⟩ := hex
      exact ⟨w x₀, w y₀, fun x => ⟨fun hx => ic_equal x x₀ (by simp [hx, h₀]),
                                      fun hx => ic_equal x y₀ (by simp [hx, hy₀])⟩⟩
    · push_neg at hex
      exact ⟨w x₀, 0, fun x => ⟨fun hx => ic_equal x x₀ (by simp [hx, h₀]),
                                   fun hx => absurd hx (by simp [hex x])⟩⟩
  · -- x₀ has l = false; need a representative for l = true
    simp at h₀
    by_cases hex : ∃ y, l y = true
    · obtain ⟨y₀, hy₀⟩ := hex
      exact ⟨w y₀, w x₀, fun x => ⟨fun hx => ic_equal x y₀ (by simp [hx, hy₀]),
                                      fun hx => ic_equal x x₀ (by simp [hx, h₀])⟩⟩
    · push_neg at hex
      exact ⟨0, w x₀, fun x => ⟨fun hx => absurd hx (by simp [hex x]),
                                   fun hx => ic_equal x x₀ (by simp [hx, h₀])⟩⟩