import _windows_dll_fix

from matplotlib import mathtext

p = mathtext.MathTextParser('agg')
print(p.parse('$\\sum$'))
