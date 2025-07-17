import pytest


def test_gpu_availability():
    """Check if GPU is available, gracefully handling environments without PyTorch."""
    try:
        import torch
    except ImportError:
        pytest.skip("PyTorch not installed - skipping GPU availability test")

    if not torch.cuda.is_available():
        pytest.skip("No GPU found - this is expected in CPU-only environments")
    # If we get here, GPU is available
    assert torch.cuda.device_count() > 0, "GPU detected but device count is 0"
