# -*- coding: utf-8 -*-
import codecs
import argparse
import random

def read_pron_data(fn):
  with codecs.open(fn, "r", 'utf-8') as file:
    lines = [l.strip() for l in file]
    tuples = [tuple(l.split("\t")) for l in lines]

  return tuples

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
  split_index = int(len(data) * .9)
  train = data[:split_index]
  dev = data[split_index:]

  train_out_src = output + "/%s-train-src" % language
  train_out_tgt = output + "/%s-train-tgt" % language
  dev_out_src = output + "/%s-dev-src" % language
  dev_out_tgt = output + "/%s-dev-tgt" % language

  with codecs.open(train_out_src, "w", 'utf-8') as src:
    src.write('\n'.join([' '.join(graphemes) for lang, alphabet, graphemes, phone_chars, phones in train]))
  with codecs.open(train_out_tgt, "w", 'utf-8') as tgt:
    tgt.write('\n'.join([' '.join(phones) for lang, alphabet, graphemes, phone_chars, phones in train]))

  with codecs.open(dev_out_src, "w", 'utf-8') as src:
    src.write('\n'.join([' '.join(graphemes) for lang, alphabet, graphemes, phone_chars, phones in dev]))
  with codecs.open(dev_out_tgt, "w", 'utf-8') as tgt:
    tgt.write('\n'.join([' '.join(phones) for lang, alphabet, graphemes, phone_chars, phones in dev]))