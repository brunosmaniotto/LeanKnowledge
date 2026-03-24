import Mathlib

open BigOperators Finset
open Topology

/-- The expected externality mechanism transfer function.
    In a quasilinear environment with statistically independent types,
    agent i's transfer is the expected sum of other agents' valuations
    under the social choice function k*, plus an arbitrary function of others' types.

    t_i(θ) = E_{θ_{-i}}[Σ_{j≠i} v_j(k*(θ_i, θ_{-i}), θ_j)] + h_i(θ_{-i})

    Due to d'Aspremont and Gérard-Varet (1979) and Arrow (1979). -/
noncomputable def expectedExternalityTransfer
    {I : Type*} [Fintype I] [DecidableEq I]
    {Θ : I → Type*} [∀ i, Fintype (Θ i)]
    {K : Type*}
    (v : I → K → ((i : I) → Θ i) → ℝ)
    (kStar : ((i : I) → Θ i) → K)
    (φ : (i : I) → Θ i → ℝ)
    (h : I → ((i : I) → Θ i) → ℝ)
    (i : I)
    (θ : (i : I) → Θ i) : ℝ :=
  let mkProfile (θ_neg_i : (j : {j : I // j ≠ i}) → Θ j) : (j : I) → Θ j :=
    fun j => if hij : j = i then hij ▸ θ i else θ_neg_i ⟨j, hij⟩
  ∑ θ_neg_i : (j : {j : I // j ≠ i}) → Θ j,
    (∏ j : {j : I // j ≠ i}, φ j (θ_neg_i j)) *
    (∑ j ∈ univ.filter (· ≠ i),
      v j (kStar (mkProfile θ_neg_i)) (mkProfile θ_neg_i))
  + h i θ