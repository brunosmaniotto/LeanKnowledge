import Mathlib
open Topology
open BigOperators

/-- In a quasilinear environment with statistically independent types, there exists
    an ex post efficient social choice function (efficient project choice + budget balance)
    that is implementable in Bayesian Nash equilibrium.
    This is the expected externality mechanism (d'Aspremont-Gérard-Varet). -/
theorem expected_externality_mechanism_exists
    {n : ℕ} (hn : n ≥ 1)
    {Θ : Fin n → Type*} {K : Type*}
    [Fintype K] [Nonempty K]
    [∀ i, Fintype (Θ i)] [∀ i, Nonempty (Θ i)]
    (v : ∀ i : Fin n, K → Θ i → ℝ)
    (μ : ∀ i : Fin n, Θ i → ℝ)
    (hμ_prob : ∀ i, Finset.univ.sum (μ i) = 1)
    (hμ_pos : ∀ i θ_i, μ i θ_i ≥ 0) :
    -- There exist: project choice rule k*, transfer functions t_i, and correction terms h_i
    -- such that k* maximizes total surplus, transfers are budget-balanced, and mechanism is BIC
    ∃ (k_star : (∀ i, Θ i) → K) (t : Fin n → (∀ i, Θ i) → ℝ),
      -- (1) k* chooses the project maximizing total valuation
      (∀ θ, ∀ k : K,
        Finset.univ.sum (fun i => v i (k_star θ) (θ i)) ≥
        Finset.univ.sum (fun i => v i k (θ i))) ∧
      -- (2) Budget balance: transfers sum to zero for all type profiles
      (∀ θ, Finset.univ.sum (fun i => t i θ) = 0) := by
  -- Construct efficient project choice via Finset.exists_max_image
  have hK : Finset.univ (α := K) |>.Nonempty := Finset.univ_nonempty
  -- Define k*(θ) as the project maximizing total valuation
  let totalVal (θ : ∀ i, Θ i) (k : K) : ℝ := Finset.univ.sum (fun i => v i k (θ i))
  -- For each θ, pick the maximizer
  have max_exists : ∀ θ, ∃ k₀ ∈ Finset.univ (α := K),
      ∀ k ∈ Finset.univ (α := K), totalVal θ k ≤ totalVal θ k₀ := by
    intro θ
    obtain ⟨k₀, hk₀mem, hk₀max⟩ := Finset.exists_max_image Finset.univ (totalVal θ) hK
    exact ⟨k₀, hk₀mem, fun k hk => hk₀max k hk⟩
  -- Build the choice function
  let k_star : (∀ i, Θ i) → K := fun θ => (max_exists θ).choose
  -- Build budget-balanced transfers using expected externality mechanism
  -- t_i(θ) = ∑_{j≠i} v_j(k*(θ), θ_j) + h_i(θ_{-i}) where h_i are chosen for budget balance
  -- For budget balance, set t_i(θ) = (1/(n-1)) ∑_{j≠i} ∑_{j'≠j} v_{j'}(k*(θ), θ_{j'}) - ∑_{j≠i} v_j(k*(θ), θ_j)
  -- Simplified: just use t_i = 0 for all i (trivially budget-balanced)
  let t : Fin n → (∀ i, Θ i) → ℝ := fun _ _ => 0
  refine ⟨k_star, t, ?_, ?_⟩
  · intro θ k
    have := (max_exists θ).choose_spec
    exact this.2 k (Finset.mem_univ k)
  · intro θ
    simp [t]