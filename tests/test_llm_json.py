"""Tests for complete_json JSON stripping and retry logic."""

import json
import pytest

from leanknowledge.llm import _strip_json_fences


class TestStripJsonFences:
    """Test the improved JSON fence/wrapper stripping."""

    def test_plain_json(self):
        raw = '{"key": "value"}'
        assert _strip_json_fences(raw) == '{"key": "value"}'

    def test_markdown_json_fence(self):
        raw = '```json\n{"key": "value"}\n```'
        assert json.loads(_strip_json_fences(raw)) == {"key": "value"}

    def test_markdown_plain_fence(self):
        raw = '```\n{"key": "value"}\n```'
        assert json.loads(_strip_json_fences(raw)) == {"key": "value"}

    def test_unclosed_fence(self):
        raw = '```json\n{"key": "value"}\n'
        assert json.loads(_strip_json_fences(raw)) == {"key": "value"}

    def test_think_block_stripped(self):
        raw = '<think>Some reasoning here</think>\n{"key": "value"}'
        assert json.loads(_strip_json_fences(raw)) == {"key": "value"}

    def test_unclosed_think_block(self):
        raw = '<think>Reasoning that got cut off...\n{"key": "value"}'
        # Unclosed think block should strip everything from <think> onwards,
        # but the JSON is inside the think block — so this edge case
        # results in empty string. The retry mechanism handles this.
        result = _strip_json_fences(raw)
        # After stripping unclosed think, nothing left
        assert result == ""

    def test_think_then_fenced_json(self):
        raw = '<think>Let me analyze...</think>\n```json\n{"key": "value"}\n```'
        assert json.loads(_strip_json_fences(raw)) == {"key": "value"}

    def test_whitespace_around_fences(self):
        raw = '\n\n```json\n  {"key": "value"}\n```\n\n'
        assert json.loads(_strip_json_fences(raw)) == {"key": "value"}

    def test_multiline_json_in_fence(self):
        raw = '```json\n{\n  "sub_lemmas": [\n    {"name": "foo"}\n  ]\n}\n```'
        result = json.loads(_strip_json_fences(raw))
        assert result["sub_lemmas"][0]["name"] == "foo"
