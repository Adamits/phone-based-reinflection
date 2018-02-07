# -*- coding: utf-8 -*-

from sys import argv, stderr
import codecs

"""
Convert data from ConLL Sigmorph shared task on morphological reinflection
to format necessary to use OpenNMT
"""

if __name__=='__main__':
  if len(argv) != 2:
        stderr.write(("USAGE: python3 %s file_with_accuracies") % argv[0])
        exit(1)

  ACCS_FN = argv[1]

  data = [l.strip().split(' ') for l in codecs.open(ACCS_FN, 'r', 'utf-8') if l.strip() != '']

  total_acc = 0
  total_lev = 0
  print(data)

  # If there are 5 things in the lin
  if len(data) == 5:
    for lang, acc_label, acc, lev_label, lev in data:
      total_acc += float(acc)
      total_lev += float(lev)

  print("AVERAGE ACCURACY: %.2f" % (total_acc / len(data)))
  print("AVERAGE LEVENSHTEIN DISTANCE: %.2f" % (total_lev / len(data)))
