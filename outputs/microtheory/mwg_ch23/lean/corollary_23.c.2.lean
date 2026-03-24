import Mathlib

variable {I : ℕ} (Θ X : Type*) [Fintype X] [Fintype Θ] [DecidableEq X]

axiom TruthfullyImplementable : (Θ → X) → Prop

axiom DictatorialOn : (Θ → X) → Set X → Prop

axiom corollary_23_C_1 (Y : Type*) [Fintype Y] (g : Θ → Y)
    (hcard : 3 ≤ Fintype.card Y)
    (himpl : TruthfullyImplementable Θ Y g) :
    DictatorialOn Θ Y g Set.univ

axiom restriction_implementable (f : Θ → X)
    (himpl : TruthfullyImplementable Θ X f) :
    TruthfullyImplementable Θ (Set.range f) (fun θ => ⟨f θ, Set.mem_range_self θ⟩)

axiom dictatorial_lift (f : Θ → X)
    (hdict : DictatorialOn Θ (Set.range f) (fun θ => ⟨f θ, Set.mem_range_self θ⟩) Set.univ) :
    DictatorialOn Θ X f (Set.range f)

axiom dictatorial_implies_implementable (f : Θ → X)
    (hdict : DictatorialOn Θ X f (Set.range f)) :
    TruthfullyImplementable Θ X f

theorem Corollary_23_C_2
    (f : Θ → X)
    (hcard : 3 ≤ Fintype.card (Set.range f)) :
    TruthfullyImplementable Θ X f ↔ DictatorialOn Θ X f (Set.range f) := by
  constructor
  · intro himpl
    have hrestr := restriction_implementable Θ X f himpl
    have hdict := corollary_23_C_1 Θ (Set.range f) (fun θ => ⟨f θ, Set.mem_range_self θ⟩) hcard hrestr
    exact dictatorial_lift Θ X f hdict
  · exact dictatorial_implies_implementable Θ X f