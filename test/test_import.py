# Copyright 2025 TEMPLATE

"""
Test that the TEMPLATE package can be imported correctly.
"""


def test_import_package():
    """Test that the package has the expected structure."""
    import TEMPLATE

    # Check that __version__ exists
    assert hasattr(TEMPLATE, "__version__"), "Package should have __version__ attribute"


def test_import_core():
    """Test that the core module can be imported."""
    from TEMPLATE import core

    assert core is not None
