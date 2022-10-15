"""Auxiliary functions"""

import itertools


def get_frames_combinations(num_frames, scale):
    """Produce frames combinations"""
    return list(itertools.combinations(range(num_frames), scale))
