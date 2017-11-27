# -*- coding: utf-8 -*-
import codecs
import argparse
import random


def read_pron_data(fn):
  # Ignore lines that we know have bad data
  IGNORE = ["}}, {{"]
  with codecs.open(fn, "r", 'utf-8') as file:
    lines = [l.strip() for l in file for i in IGNORE if i not in l]
    tuples = [tuple(l.split("\t")) for l in lines]

  return tuples


def structure_data(characters):
  """
  Note this is written with just the Finnish diachritics in mind. This will have to be expanded
  to be more exhaustive if we continue to experiment with other languages
  """
  # Ignore superfluous diachritics and optional symbol
  IGNORE = ["ˈ", "ˌ", "'", "̪", "̞", "ˣ", "̯", "-", "(", ")", "[", "]"]
  out = []
  for i, c in enumerate(characters):
    if c in IGNORE:
      continue
    # "ː" should be part of the character (no space between), also account for variation
    # in vowel length character used
    elif c == "ː" or c == ":":
      out[-1] += "ː"
    # Do not add the optional characters, either (In Finnish seems to just be a glottal stop)
    elif i > 0 and characters[i-1] == "(" and characters[i + 1] == ")":
      continue
    else:
      out.append(c)

  return ' '.join(out)

if __name__=='__main__':
  parser = argparse.ArgumentParser(description='convert the phoible aligned wiki data to a representation that can be an input to Opennmt-py')
  parser.add_argument('-i', '--input', help='Input file from pron_data', required=True)
  parser.add_argument('-o', '--output', help='Output file fthat will be the input for Opennmt-py', required=True)
  parser.add_argument('-l', '--language', help='The language to retrieve data from', required=True)
  parser.add_argument('-lc', '--language_code', help='The language code to retrieve data from', required=True)

  args = vars(parser.parse_args())

  # GET VARIABLES FROM ARGS
  input = args.get("input")
  output = args.get("output")
  language = args.get("language")
  language_code  = args.get("language_code")

  #Train/Dev split
  data = [l for l in read_pron_data(input) if l[0] == language_code]
  random.shuffle(data)
  split_index = int(len(data) * .8)
  train = data[:split_index]
  dev = data[split_index:]

  train_out_src = output + "/%s-train-src" % language
  train_out_tgt = output + "/%s-train-tgt" % language
  dev_out_src = output + "/%s-dev-src" % language
  dev_out_tgt = output + "/%s-dev-tgt" % language

  with codecs.open(train_out_src, "w", 'utf-8') as src:
    src.write('\n'.join([structure_data(graphemes) for lang, alphabet, graphemes, phone_chars, phones in train]))
  with codecs.open(train_out_tgt, "w", 'utf-8') as tgt:
    tgt.write('\n'.join([structure_data(phones) for lang, alphabet, graphemes, phone_chars, phones in train]))

  with codecs.open(dev_out_src, "w", 'utf-8') as src:
    src.write('\n'.join([structure_data(graphemes) for lang, alphabet, graphemes, phone_chars, phones in dev]))
  with codecs.open(dev_out_tgt, "w", 'utf-8') as tgt:
    tgt.write('\n'.join([structure_data(phones) for lang, alphabet, graphemes, phone_chars, phones in dev]))