# -*- coding: utf-8 -*-

from sys import argv, stderr
import codecs

"""
Convert data from ConLL Sigmorph shared task on morphological reinflection
to format necessary to use OpenNMT to convert to IPA with trained model
"""

if __name__=='__main__':
  if len(argv) != 3:
        stderr.write(("USAGE: python3 %s data_file output") % argv[0])
        exit(1)

  FN = argv[1]
  output = argv[2]

  print("generating ONMT formatted data...")

  data = [l.strip().split('\t') for l in codecs.open(FN, 'r', 'utf-8') if l.strip() != '']

  with codecs.open(output + "/" + FN.split("/")[-1] + "-lemmas.txt", "w", 'utf-8') as out_lemmas:
    out_lemmas.write("\n".join([" ".join([l if l != ' ' else '#' for l in lemma]) for lemma, _, _ in data]))

  with codecs.open(output + "/" + FN.split("/")[-1] + "-labels.txt", "w", 'utf-8') as out_labels:
    out_labels.write("\n".join([" ".join(labels.split(";")) for _, _, labels in data]))

  with codecs.open(output + "/" + FN.split("/")[-1] + "-word_forms.txt", "w", 'utf-8') as out_wf:
    out_wf.write("\n".join([" ".join([w if w != ' ' else '#' for w in wf]) for _, wf, _ in data]))
