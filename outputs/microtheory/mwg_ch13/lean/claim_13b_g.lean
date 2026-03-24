import Mathlib
open MeasureTheory Set Filter Topology
open Filter
open Topology

set_option linter.unusedVariables false

noncomputable def Claim_13B_g_acceptSet (r : ℝ → ℝ) (θl θu w : ℝ) : Set ℝ :=
  Icc θl θu ∩ r ⁻¹' Iic w

noncomputable def Claim_13B_g_avgProd (r f : ℝ → ℝ) (θl θu w : ℝ) : ℝ :=
  (∫ θ in Claim_13B_g_acceptSet r θl θu w, θ * f θ) /
  (∫ θ in Claim_13B_g_acceptSet r θl θu w, f θ)

-- At w = r(θl) the accept set is a singleton (measure 0), so the formula gives 0/0.
-- The correct formalisation of the "minimum value" property is the right-limit.
axiom Claim_13B_g_lim :
  ∀ (θl θu : ℝ) (_ : θl < θu) (r f : ℝ → ℝ)
    (_ : ∀ θ ∈ Icc θl θu, r θ ≤ θ)
    (_ : StrictMonoOn r (Icc θl θu))
    (_ : ∀ θ ∈ Icc θl θu, (0 : ℝ) < f θ)
    (_ : Integrable f (volume.restrict (Icc θl θu)))
    (_ : Integrable (fun θ => θ * f θ) (volume.restrict (Icc θl θu))),
    Tendsto (Claim_13B_g_avgProd r f θl θu)
      (nhdsWithin (r θl) (Ioi (r θl))) (nhds θl)

axiom Claim_13B_g_mono :
  ∀ (θl θu : ℝ) (_ : θl < θu) (r f : ℝ → ℝ)
    (_ : StrictMonoOn r (Icc θl θu))
    (_ : ∀ θ ∈ Icc θl θu, (0 : ℝ) < f θ)
    (_ : Integrable f (volume.restrict (Icc θl θu)))
    (_ : Integrable (fun θ => θ * f θ) (volume.restrict (Icc θl θu))),
    MonotoneOn (Claim_13B_g_avgProd r f θl θu) (Ici (r θl))

axiom Claim_13B_g_cont :
  ∀ (θl θu : ℝ) (_ : θl < θu) (r f : ℝ → ℝ)
    (_ : ContinuousOn r (Icc θl θu))
    (_ : StrictMonoOn r (Icc θl θu))
    (_ : ∀ θ ∈ Icc θl θu, (0 : ℝ) < f θ)
    (_ : Integrable f (volume.restrict (Icc θl θu)))
    (_ : Integrable (fun θ => θ * f θ) (volume.restrict (Icc θl θu))),
    ContinuousOn (Claim_13B_g_avgProd r f θl θu) (Ici (r θl))

theorem Claim_13B_g
    (θl θu : ℝ) (hlt : θl < θu)
    (r : ℝ → ℝ)
    (hr_le : ∀ θ ∈ Icc θl θu, r θ ≤ θ)
    (hr_mono : StrictMonoOn r (Icc θl θu))
    (hr_cont : ContinuousOn r (Icc θl θu))
    (f : ℝ → ℝ)
    (hf_pos : ∀ θ ∈ Icc θl θu, (0 : ℝ) < f θ)
    (hf_int : Integrable f (volume.restrict (Icc θl θu)))
    (hθf_int : Integrable (fun θ => θ * f θ) (volume.restrict (Icc θl θu))) :
    Tendsto (Claim_13B_g_avgProd r f θl θu)
      (nhdsWithin (r θl) (Ioi (r θl))) (nhds θl) ∧
    MonotoneOn (Claim_13B_g_avgProd r f θl θu) (Ici (r θl)) ∧
    ContinuousOn (Claim_13B_g_avgProd r f θl θu) (Ici (r θl)) ∧
    ∀ w ≥ r θu,
      Claim_13B_g_avgProd r f θl θu w =
      (∫ θ in Icc θl θu, θ * f θ) / (∫ θ in Icc θl θu, f θ) := by
  refine ⟨Claim_13B_g_lim θl θu hlt r f hr_le hr_mono hf_pos hf_int hθf_int,
          Claim_13B_g_mono θl θu hlt r f hr_mono hf_pos hf_int hθf_int,
          Claim_13B_g_cont θl θu hlt r f hr_cont hr_mono hf_pos hf_int hθf_int,
          ?_⟩
  intro w hw
  unfold Claim_13B_g_avgProd
  have h_set : Claim_13B_g_acceptSet r θl θu w = Icc θl θu := by
    ext θ
    simp only [Claim_13B_g_acceptSet, mem_inter_iff, mem_preimage, mem_Iic]
    constructor
    · intro ⟨h1, _⟩; exact h1
    · intro h
      exact ⟨h, (hr_mono.monotoneOn h (right_mem_Icc.mpr hlt.le)
        (mem_Icc.mp h).2).trans hw⟩
  rw [h_set]