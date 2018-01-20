# -*- coding: utf-8 -*-

from sys import argv, stderr
import codecs
from util import *

"""
Convert data from ConLL Sigmorph shared task on morphological reinflection
to format necessary to use OpenNMT using epitran to get the phonemic representation
of each character
"""

if __name__=='__main__':
  if len(argv) != 3:
        stderr.write(("USAGE: python3 %s data_file output") % argv[0])
        exit(1)

  lang = argv[1]
  FN = argv[2]
  output = argv[3]

  data = [l.strip().split('\t') for l in codecs.open(FN, 'r', 'utf-8') if l.strip() != '']

  # Get the phonemic version of the text
  lemmas = [get_phones(lang, lemma) for lemma, _, _ in data]
  wfs = [get_phones(lang, wf) for _, wf, _ in data]

  # Preprocess those phones into ONMT format
  lemmas = [" ".join([l if l != ' ' else '#' for l in lemma]) for lemma in lemmas]
  wfs = " ".join([w if w != ' ' else '#' for w in wf]) for wf in wfs]

  # ONMT format for labels
  labels = " ".join(labels.split(";") for _, _, labels in data]

  # Output src/tgt files for ONMT. Notice this will work for train AND dev files
  with codecs.open(output + "/" + FN.split("/")[-1] + "-src.txt", "w", "utf-8") as out:
    out.write("\n".join([lem + " " + lab for lem, lab in zip(lemmas, labels)]))

  with codecs.open(output + "/" + FN.split("/")[-1] + "-tgt.txt", "w", "utf-8") as out:
    out.write("\n".join([wf for wf in wfs]))
