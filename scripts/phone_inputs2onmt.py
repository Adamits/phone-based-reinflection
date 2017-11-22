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

  lemmas = [l.strip() for l in codecs.open(FN + "-lemmas", 'r', 'utf-8')]
  wfs = [l.strip() for l in codecs.open(FN + "-word_forms", 'r', 'utf-8')]
  labels = [l.strip() for l in codecs.open(FN.replace("onmt-phone-inputs", "onmt-character-inputs") + "-labels", 'r', 'utf-8')]

  out_fn = output + FN.split("/")[-1]
  with codecs.open(out_fn + "-src.txt", "w", "utf-8") as out:
    out.write("\n".join([lem + " " + lab for lem, lab in zip(lemmas, labels)]))

  with codecs.open(out_fn + "-tgt.txt", "w", "utf-8") as out:
    out.write("\n".join([wf for wf in wfs]))
