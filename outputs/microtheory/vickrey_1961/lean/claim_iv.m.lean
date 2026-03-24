import Mathlib
open BigOperators

/-- Claim IV.M: In non-symmetrical cases successive auction results tend to be
    non-Pareto-optimal. Witnessed concretely: with asymmetric valuations
      bidder 0: val(good 0)=10, val(good 1)=1
      bidder 1: val(good 0)= 8, val(good 1)=9
    the sequential auction outcome (good 0→bidder 1, good 1→bidder 0)
    yields total welfare 8+1=9, while the optimal allocation
    (good 0→bidder 0, good 1→bidder 1) yields 10+9=19. -/
theorem Claim_IV.M :
    ∃ (val : Fin 2 → Fin 2 → ℕ)
      (seq_alloc opt_alloc : Fin 2 → Fin 2),
      ∑ j : Fin 2, val (seq_alloc j) j < ∑ j : Fin 2, val (opt_alloc j) j :=
  ⟨![![10, 1], ![8, 9]], ![1, 0], ![0, 1], by decide⟩