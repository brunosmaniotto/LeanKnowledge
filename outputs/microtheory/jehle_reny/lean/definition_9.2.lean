import Mathlib

/-- A direct selling mechanism for bidders of type `I`, specified by
    interim winning probabilities p̄_i and interim expected costs c̄_i,
    each as a function of the reported value r_i ∈ [0,1]. -/
structure DirectSellingMechanism (I : Type*) where
  /-- Interim probability that bidder i wins, given report r_i -/
  p_bar : I → ℝ → ℝ
  /-- Interim expected cost to bidder i, given report r_i -/
  c_bar : I → ℝ → ℝ

/-- A direct selling mechanism is incentive-compatible if for each bidder i
    and each true value v_i ∈ [0,1], the expected payoff
    u_i(r_i, v_i) = p̄_i(r_i) · v_i − c̄_i(r_i)
    is maximized when the report r_i equals the true value v_i. -/
def DirectSellingMechanism.IsIncentiveCompatible {I : Type*}
    (m : DirectSellingMechanism I) : Prop :=
  ∀ (i : I) (v_i : ℝ), v_i ∈ Set.Icc (0 : ℝ) 1 →
    ∀ (r_i : ℝ), r_i ∈ Set.Icc (0 : ℝ) 1 →
      m.p_bar i r_i * v_i - m.c_bar i r_i ≤
        m.p_bar i v_i * v_i - m.c_bar i v_i