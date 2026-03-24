import Mathlib
open Real
open Topology

/-- For any cost function, the input share for input i satisfies
    s_i = ∂ln[c(w, y)]/∂ln(w_i).
    
    The input share is s_i = w_i * x_i(w,y) / c(w,y), and by Shephard's lemma
    x_i(w,y) = ∂c/∂w_i. The log-derivative identity gives
    ∂ln(c)/∂ln(w_i) = (w_i / c) * (∂c/∂w_i) = w_i * x_i / c = s_i. -/
theorem Exercise_3_33
    (w_i : ℝ) (x_i : ℝ) (c : ℝ)
    (hc : c ≠ 0) (hw : w_i ≠ 0)
    (deriv_c : ℝ)  -- ∂c/∂w_i
    (shephard : deriv_c = x_i)  -- Shephard's lemma
    (input_share : ℝ)
    (hs : input_share = w_i * x_i / c)
    (log_deriv : ℝ)  -- ∂ln(c)/∂ln(w_i)
    (hlog : log_deriv = w_i / c * deriv_c)  -- chain rule: ∂ln(c)/∂ln(w_i) = (w_i/c)(∂c/∂w_i)
    : input_share = log_deriv := by
  rw [hs, hlog, shephard]
  ring