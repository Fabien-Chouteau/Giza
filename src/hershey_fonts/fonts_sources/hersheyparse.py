#!/usr/bin/python
# hersheyparse.py - simple Hershey Font file parser
# as an example, writes data to a JSON file
# ** NB: Requires input to be cleaned of broken lines **
# scruss - 2014-06-01 - WTFPL (srsly)

# Modified to generate Ada specs

from string import split
import sys
import os
import string


def char2val(c):  # data is stored as signed bytes relative to ASCII R
    return ord(c) - ord('R')


def hersh_bbox(lines):
    """ passed an array of lines, returns the smallest bounding box """

    # nice ways of bombing out
    if lines is None:
        return None
    if len(lines[0]) < 1:
        return None
    min_x = max_x = lines[0][0][0]
    min_y = max_y = lines[0][0][1]
    for line in lines:
        for pt in line:
            if pt[0] < min_x:
                min_x = pt[0]
            if pt[1] < min_y:
                min_y = pt[1]
            if pt[0] > max_x:
                max_x = pt[0]
            if pt[1] > max_y:
                max_y = pt[1]
    return ((min_x, min_y), (max_x, max_y))


def hersheyparse(dat, code):
    """ reads a line of Hershey font text """

    lines = []

    # individual lines are stored separated by <space>+R
    # starting at col 11

    for s in split(dat[10:], ' R'):

        # each line is a list of pairs of coordinates
        # NB: origin is at centre(ish) of character
        #     Y coordinates **increase** downwards

        line = map(None, *[iter(map(char2val, list(s)))] * 2)
        lines.append(line)
    glyph = {  # character code in columns 1-6; it's not ASCII
               # indicative number of vertices in columns 6-9 ** NOT USED **
               # left side bearing encoded in column 9
               # right side bearing encoded in column 10
        # In the file I have the columns 1-6 are always 12345, so we take line
        # number as charcode
        #'charcode': int(dat[0:5]),
        'charcode': int(code),
        'left': char2val(dat[8]),
        'right': char2val(dat[9]),
        'lines': lines,
        }
    glyph['bbox'] = hersh_bbox(glyph['lines'])
    return glyph


hershey = []
f = open(sys.argv[1], 'r')
code = 0
for line in f:
    g = hersheyparse(line.rstrip(), code)
    code += 1
    if g is not None:
        hershey.append(g)
f.close()
#print json.dumps(hershey, sort_keys=True, separators=(',', ':'))


class Raise_Pen(object):
    def __repr__(self):
        return 'Raise_Pen'


def flatten(list_of_list):
    # chain('ABC', 'DEF') --> A B C D E F
    ret = []
    for it in list_of_list:
        if isinstance(it, list):
            ret += [Raise_Pen()] + it
        else:
            ret += [it]

    return ret


def glyph_to_ada(glyph):
    flat = flatten(glyph['lines'])
    flat = map(lambda x: str(x), flat)
    if len(flat) <= 1:
        flat = []
    glyph_str = "   Glyph_%s : aliased constant Glyph :=\n" \
                % str(glyph['charcode'])
    glyph_str += '     (Number_Of_Vectors => %d,\n' % len(flat)
    glyph_str += '      Charcode => %d,\n' % glyph['charcode']
    glyph_str += '      Left => %d,\n' % glyph['left']
    glyph_str += '      Right => %d,\n' % glyph['right']
    if glyph['bbox'] is not None:
        glyph_str += '      Top => %d,\n' % glyph['bbox'][0][1]
        glyph_str += '      Bottom => %d,\n' % glyph['bbox'][1][1]
    else:
        glyph_str += '      Top => 0,\n'
        glyph_str += '      Bottom => 0,\n'
    if len(flat) == 0:
        glyph_str += '      Vects => (others => (Raise_Pen)));'
    else:
        glyph_str += '      Vects => (%s)));' % ",\n".join(flat)[:-1]
    return glyph_str + '\n'

ada_glyphs = ''
for glyph in hershey:
    ada_glyphs += glyph_to_ada(glyph)

pck_name = os.path.basename(sys.argv[1])[:-4]
pck_name = 'Giza.Hershey_Fonts.%s' % string.capwords(pck_name)

pck = 'package %s is\n' % pck_name
pck += '   Font : constant Font_Ref;\n'
pck += 'private\n'
pck += ada_glyphs + '\n'
pck += '   Font_D : aliased constant Hershey_Font :=\n'
pck += '     (Number_Of_Glyphs => %d,\n' % len(hershey)
pck += '      Glyphs =>\n'
pck += '        (\n'
for glyph in hershey[:-1]:
    pck += '         Glyph_%s\'Access,\n' % glyph['charcode']
pck += '         Glyph_%s\'Access\n' % hershey[-1]['charcode']
pck += '        ));\n'
pck += '   Font : constant Font_Ref := Font_D\'Access;\n'
pck += 'end %s;' % pck_name

print pck
