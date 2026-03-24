import Mathlib
open BigOperators

/-- The Clarke (pivotal) mechanism transfer for agent i.
    Agent i pays: [Σ_{j≠i} v_j(k*(θ), θ_j)] - [Σ_{j≠i} v_j(k*_{-i}(θ_{-i}), θ_j)]
    This equals zero when i is not pivotal (k*(θ) = k*_{-i}(θ_{-i}))
    and is negative when i is pivotal. -/
noncomputable def clarkeMechanismTransfer
    {I : Type*} [Fintype I] [DecidableEq I]
    {K : Type*} [Fintype K] [Nonempty K]
    {Θ : I → Type*}
    (v : (i : I) → K → Θ i → ℝ)
    (i : I)
    (θ : (j : I) → Θ j) : ℝ :=
  let kStar := Classical.choose (Finite.exists_max
    (f := fun k => ∑ j, v j k (θ j)))
  let θ_neg_i : (j : I) → Θ j := θ
  let kStar_neg_i := Classical.choose (Finite.exists_max
    (f := fun k => ∑ j ∈ Finset.univ.filter (· ≠ i), v j k (θ j)))
  (∑ j ∈ Finset.univ.filter (· ≠ i), v j kStar (θ j)) -
  (∑ j ∈ Finset.univ.filter (· ≠ i), v j kStar_neg_i (θ j))