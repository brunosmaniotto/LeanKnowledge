import Mathlib
open Topology

-- Model the economic setting abstractly
variable {X : Type*} [TopologicalSpace X]
variable {ι : Type*}

/--
If preferences are locally nonsatiated, then
  "x_i ≻_i x*_i ⟹ p · x_i ≥ p · x*_i"
is equivalent to
  "x*_i is expenditure minimizing at p over {x_i ∈ X_i : x_i ≿_i x*_i}".
-/
theorem Claim_16D_exercise1
    (Xi : Set ι)           -- consumption set
    (pref : ι → ι → Prop)  -- weak preference ≿
    (spref : ι → ι → Prop) -- strict preference ≻
    (cost : ι → ℝ)         -- p · x_i
    (xstar : ι)            -- x*_i
    (hXi : xstar ∈ Xi)
    -- strict preference means: weakly preferred and not weakly preferred the other way
    (spref_def : ∀ x, spref x xstar ↔ (pref x xstar ∧ ¬ pref xstar x))
    -- local nonsatiation: for any x in Xi, there exists y in Xi strictly preferred to xstar
    -- that is arbitrarily close (we abstract this as: if x ≿ xstar then for any cost bound,
    -- there exists y ≻ xstar with cost y < cost x + ε, but we simplify to the key consequence)
    -- Key consequence of local nonsatiation: if p · x < p · xstar and x ≿ xstar,
    -- then there exists y ≻ xstar with p · y < p · xstar (contradiction with the LHS condition)
    (local_ns : ∀ x ∈ Xi, pref x xstar → cost x < cost xstar →
      ∃ y ∈ Xi, spref y xstar ∧ cost y < cost xstar)
    -- reflexivity of weak preference
    (pref_refl : pref xstar xstar) :
    -- LHS: strict preference implies at least as expensive
    (∀ x ∈ Xi, spref x xstar → cost x ≥ cost xstar) ↔
    -- RHS: xstar minimizes expenditure over upper contour set
    (∀ x ∈ Xi, pref x xstar → cost x ≥ cost xstar) := by
  constructor
  · -- (→) If strict pref implies ≥ cost, then weak pref implies ≥ cost
    intro h x hx hpref
    by_contra hlt
    push_neg at hlt
    obtain ⟨y, hy, hspy, hcy⟩ := local_ns x hx hpref hlt
    have := h y hy hspy
    linarith
  · -- (←) If weak pref implies ≥ cost, then strict pref implies ≥ cost (immediate weakening)
    intro h x hx hspref
    have hpref := (spref_def x).mp hspref
    exact h x hx hpref.1