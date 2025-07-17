import pytest


def test_isaaclab_existeence():
    try:
        from isaaclab.app import AppLauncherimport  # noqa: F401
    except ImportError:
        pytest.skip(
            "Try pixi r install-isaaclab if your computer has an NVIDIA GPU to activate the isaaclab feature"
        )
    assert True, "Isaac Lab is installed"
