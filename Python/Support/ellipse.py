import numpy as np

def ellipse(amat, level, n=100, shift=None):
    if shift is None:
        shift = np.array([0, 0])

    shift = np.asarray(shift)

    if shift.shape != (2,):
        if shift.shape == (2, 1):
            shift = shift.flatten()
        else:
            raise ValueError('shift must be a 2-element row vector')

    # Use eigh instead of eig for symmetric matrices
    dl, v = np.linalg.eigh(amat / level)
    l = np.diag(dl)

    if np.any(np.imag(dl)) or np.any(dl <= 0):
        raise ValueError('ellipse: amat must be positive definite')

    # Generate contour data
    a = 1 / np.sqrt(dl[0])
    b = 1 / np.sqrt(dl[1])

    t = np.linspace(0, 2 * np.pi, n)
    xt = a * np.cos(t)
    yt = b * np.sin(t)

    # Rotate the contours
    ra = np.arctan2(v[1, 0], v[0, 0])

    cos_ra = np.cos(ra)
    sin_ra = np.sin(ra)

    x = xt * cos_ra - yt * sin_ra + shift[0]
    y = xt * sin_ra + yt * cos_ra + shift[1]

    # Endpoints of the major and minor axes
    minor = (v @ np.diag([a, b])).T
    major = minor.copy()

    major[1, :] = -major[0, :]
    minor[0, :] = -minor[1, :]

    t = np.array([shift, shift])
    major += t
    minor += t

    # Bounding box for the ellipse using magic formula
    ainv = np.linalg.inv(amat)
    xbox = np.sqrt(level * ainv[0, 0])
    ybox = np.sqrt(level * ainv[1, 1])

    bbox = np.array([
        [xbox, ybox],
        [xbox, -ybox],
        [-xbox, -ybox],
        [-xbox, ybox],
        [xbox, ybox]
    ])

    t = np.tile(shift, (5, 1))
    bbox += t

    return x, y, major, minor, bbox