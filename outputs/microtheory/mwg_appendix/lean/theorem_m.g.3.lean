import Mathlib

open Set

/-- **Supporting Hyperplane Theorem** (MWG Theorem M.G.3): If B is convex with
nonempty interior and x ∉ interior B, there exists a nonzero continuous linear
functional f such that f(y) ≤ f(x) for all y ∈ B. -/
theorem Theorem_MG3_supporting_hyperplane
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {B : Set E} (hB : Convex ℝ B) (hBi : (interior B).Nonempty)
    {x : E} (hx : x ∉ interior B) :
    ∃ f : E →L[ℝ] ℝ, f ≠ 0 ∧ ∀ y ∈ B, f y ≤ f x := by
  -- interior B is open and convex; separate x from it via geometric Hahn-Banach
  obtain ⟨f, hf⟩ := geometric_hahn_banach_open_point hB.interior isOpen_interior hx
  refine ⟨f, ?_, ?_⟩
  · -- f ≠ 0: if f = 0 then f a < f x gives 0 < 0
    intro hf0
    obtain ⟨a, ha⟩ := hBi
    have := hf a ha
    rw [hf0] at this
    simp at this
  · -- For y ∈ B: use B ⊆ closure B = closure (interior B) and continuity of f
    intro y hy
    have hcl := hB.closure_interior_eq_closure_of_nonempty_interior hBi
    have : y ∈ closure (interior B) := hcl ▸ subset_closure hy
    exact closure_minimal (fun a ha => (hf a ha).le)
      (isClosed_le f.continuous continuous_const) this