import pytest
import shutil
from pathlib import Path
from leanknowledge.backlog import Backlog
from leanknowledge.strategy_kb import StrategyKB

@pytest.fixture
def temp_dir(tmp_path):
    """Provide a temporary directory for file operations."""
    return tmp_path

@pytest.fixture
def mock_backlog(temp_dir):
    """Provide a Backlog instance backed by a temp file."""
    backlog_path = temp_dir / "backlog.json"
    return Backlog(path=backlog_path)

@pytest.fixture
def mock_strategy_kb(temp_dir):
    """Provide a StrategyKB instance backed by a temp file."""
    kb_path = temp_dir / "strategy_kb.json"
    return StrategyKB(path=kb_path)
