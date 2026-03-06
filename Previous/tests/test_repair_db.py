import pytest
from leanknowledge.lean.repair_db import RepairDB
from leanknowledge.lean.errors import CompilerError, ErrorCategory

@pytest.fixture
def repair_db():
    return RepairDB()

def test_tier_a_missing_tactic(repair_db):
    code = "theorem t : True := by linarith"
    error = CompilerError(
        message="unknown tactic 'linarith'",
        category=ErrorCategory.TACTIC,
        line=1
    )
    
    fixed_code, fixes = repair_db.try_repair(code, [error])
    
    assert fixed_code is not None
    assert "import Mathlib.Tactic.Linarith" in fixed_code.code
    assert "Tier A" in fixes[0]

def test_tier_a_prop_bool(repair_db):
    code = "def f (x : Nat) := if x > 0 then 1 else 0"
    # Simulated error line for 'x > 0'
    error = CompilerError(
        message="type mismatch: expected Prop, got Bool",
        category=ErrorCategory.TYPE_MISMATCH,
        line=1
    )
    
    fixed_code, fixes = repair_db.try_repair(code, [error])
    
    # The regex in repair_db expects `if ... then`
    # It tries to wrap condition in `((...) : Prop)`
    
    assert fixed_code is not None
    assert "if ((x > 0) : Prop) then" in fixed_code.code

def test_tier_b_type_coercion(repair_db):
    code = """def f (n : ℕ) : ℤ := 
  n"""
    # Simulated error: expected ℤ got ℕ
    error = CompilerError(
        message="""type mismatch
      expected: ℤ
      got: ℕ""",
        category=ErrorCategory.TYPE_MISMATCH,
        line=2
    )
    
    fixed_code, fixes = repair_db.try_repair(code, [error])

    assert fixed_code is not None
    # Expects n to be cast to ↑n
    assert "↑n" in fixed_code.code
    assert "Tier B" in fixes[0]
def test_no_repair(repair_db):
    code = "theorem t : False := sorry"
    error = CompilerError(
        message="random error",
        category=ErrorCategory.UNKNOWN,
        line=1
    )
    
    fixed_code, fixes = repair_db.try_repair(code, [error])
    assert fixed_code is None
    assert len(fixes) == 0
