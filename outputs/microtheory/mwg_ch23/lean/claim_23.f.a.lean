import Mathlib
open Topology

structure InterimVsExAnte where
  interim_f : Fin 2 → Fin 2 → ℝ
  interim_ftilde : Fin 2 → Fin 2 → ℝ
  prior : Fin 2 → ℝ
  prior_nonneg : ∀ t, 0 ≤ prior t
  prior_sum : prior 0 + prior 1 = 1

noncomputable def exAnteUtility (s : InterimVsExAnte) (i : Fin 2) (interim : Fin 2 → Fin 2 → ℝ) : ℝ :=
  s.prior 0 * interim i 0 + s.prior 1 * interim i 1

theorem ex_ante_more_demanding_than_interim :
    ∃ (s : InterimVsExAnte),
      (∀ i : Fin 2, exAnteUtility s i s.interim_ftilde > exAnteUtility s i s.interim_f) ∧
      (∃ i : Fin 2, ∃ t : Fin 2, s.interim_ftilde i t < s.interim_f i t) := by
  refine ⟨{
    interim_f := fun _ _ => 5
    interim_ftilde := fun i t =>
      if i = 0 ∧ t = 0 then 4
      else if i = 0 ∧ t = 1 then 8
      else if i = 1 ∧ t = 0 then 7
      else 6
    prior := fun t => if t = (0 : Fin 2) then 1/2 else 1/2
    prior_nonneg := fun t => by split_ifs <;> norm_num
    prior_sum := by norm_num
  }, ?_, ?_⟩
  · intro i
    simp only [exAnteUtility]
    fin_cases i <;> simp <;> norm_num
  · exact ⟨0, 0, by simp; norm_num⟩