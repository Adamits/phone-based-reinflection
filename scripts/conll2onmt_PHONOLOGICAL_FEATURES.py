# -*- coding: utf-8 -*-

from sys import argv, stderr
import codecs
from util import *
import epitran
import panphon

"""
Convert data from ConLL Sigmorph shared task on morphological reinflection
to format necessary to use OpenNMT using epitran to get the phonological feature representation
of each character
"""

"""
+feature -feature etc #
"""

def int2sym(v):
  if v == 1:
    return "+"
  elif v == 0:
    return "0"
  elif v == -1:
    return "-"

def feature_extraction(epi, ft, text):
  """
  Given a piece of text (assumed to be a lemma for WF), generate a string of phonological features
  in the form of +feature -feature 0feature, with # for a character boundary, and $ for a word boundary
  """
  features = []
  phones_list = [get_phones(epi, w) for w in text.split(" ")]
  for phones in phones_list:
    feature_strings = []
    for f in get_features(ft, phones=phones):
      feature_strings.append(" ".join(["%s%s" % (int2sym(v), k)  for k, v in f.items()]))
    features.append(" # ".join(feature_strings))

  return " $ ".join(features)

if __name__=='__main__':
  if len(argv) != 4:
        stderr.write(("USAGE: python3 %s lang data_file output") % argv[0])
        exit(1)

  lang = argv[1]
  FN = argv[2]
  output = argv[3]

  epi = epitran.Epitran(lang2ISO(lang))
  ft = panphon.FeatureTable()

  data = [l.strip().split('\t') for l in codecs.open(FN, 'r', 'utf-8') if l.strip() != '']

  # Get the feature version of the text
  lemma_features = [feature_extraction(epi, ft, lemma) for lemma, _, _ in data]
  wf_features = [feature_extraction(epi, ft, wf) for _, wf, _ in data]

  # ONMT format for labels
  labels = [" ".join(labels.split(";")) for _, _, labels in data]

  # Output src/tgt files for ONMT. Notice this will work for train AND dev files
  with codecs.open(output + "-src.txt", "w", "utf-8") as out:
    out.write("\n".join([lem + " " + lab for lem, lab in zip(lemma_features, labels)]))

  with codecs.open(output + "-tgt.txt", "w", "utf-8") as out:
    out.write("\n".join([wf for wf in wfs]))