import Mathlib
open Topology

/-- In Example 9.3, v_i(S, t_i) = t_i + 5 and v_i(B, t_i) = 2 * t_i.
    An individual strictly prefers S iff t_i < 5, strictly prefers B iff t_i > 5,
    and is indifferent iff t_i = 5. -/
theorem claim_9_5_1_a (t : ℤ) :
    (t + 5 > 2 * t ↔ t < 5) ∧
    (2 * t > t + 5 ↔ t > 5) ∧
    (t + 5 = 2 * t ↔ t = 5) := by
  refine ⟨⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩⟩ <;> intro h <;> omega