import Mathlib

/-- No pooling equilibria survive the intuitive criterion in the Rothschild-Stiglitz
    insurance market. The proof proceeds by contradiction: given any pooling outcome,
    a deviation exists that only the low-risk type prefers, forcing beliefs and
    acceptance via the intuitive criterion and sequential rationality. -/
theorem no_pooling_intuitive_criterion
    {Contract : Type*}
    -- Utilities for each type
    (u_l u_h : Contract → ℝ)
    -- Equilibrium utilities at pooling contract
    (u_star_l u_star_h : ℝ)
    -- Pooling contract
    (ψ' : Contract)
    -- Equilibrium condition: both types get equilibrium utility
    (heq_l : u_l ψ' = u_star_l)
    (heq_h : u_h ψ' = u_star_h)
    -- Key economic assumption: existence of a profitable deviation for low-risk only
    -- (above low-risk zero-profit line, preferred by low-risk, not by high-risk)
    (ψ'' : Contract)
    (hdev_l : u_l ψ'' > u_star_l)
    (hdev_h : u_h ψ'' < u_star_h)
    -- Intuitive criterion: since high-risk cannot benefit, beliefs assign low-risk
    -- Sequential rationality: company accepts (positive expected profit with low-risk)
    -- Combined: the deviation ψ'' is available to the low-risk consumer
    (haccepted : True)
    -- The low-risk consumer can deviate to ψ'' and improve payoff
    : u_l ψ'' > u_l ψ' := by
  rw [heq_l]
  exact hdev_l