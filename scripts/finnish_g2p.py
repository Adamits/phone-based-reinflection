#!/usr/bin/python
# -*- coding: utf-8 -*-
import argparse
import codecs

CONSONANTS = './data/CONSONANTS'
VOWELS = './data/VOWELS'

def load_mappings(file_path):
  ret_dict = {}

  with codecs.open(file_path, "r") as file:
    lines = [l.strip() for l in file]
    for line in lines:
      g, p = line.split('\t')
      for grapheme in g.split(","):
        ret_dict.setdefault(grapheme, [])
        for phoneme in p.split(","):
          ret_dict[grapheme].append(phoneme)

  return ret_dict

"""
Need to check potential bigrams in left and right context,
choose one if it exists, and then account for lookahead/behind in order
to decide which bigram to keep, and finally
do unigram g2p in cases where no bigram transformation was made
"""
def g2p(word, g2p_mappings):
  # Add a word boundary '#' in front of each word
  chars = ["#"]
  chars += [c for c in word]
  # Add a word boundary '#' at the end of each word
  chars.append("#")
  phones_out = ""

  # Flag if the c + rc bigram was used
  right_context = False
  for lc, c, rc in zip(chars, chars[1:], chars[2:]):
    print(lc, c, rc)
    # If the bigram in the left contexts, and only that bigram matches a key
    if g2p_mappings.get(lc + c) and not g2p_mappings.get(c + rc) and not right_context:
      right_context = False
      phones = g2p_mappings.get(lc + c)
      # For now, we will not worry about disambiguation, and just take the first phone
      phones_out += phones[0]
    # If the bigram in the right contexts, and only that bigram matches a key
    elif g2p_mappings.get(c + rc) and not g2p_mappings.get(lc + c):
      # Set the flag to true so the next iteration knows
      right_context = True
      phones = g2p_mappings.get(c + rc)
      # For now, we will not worry about disambiguation, and just take the first phone
      phones_out += phones[0]
    # If both left and right context could match a key
    elif (g2p_mappings.get(c + rc) or right_context) and g2p_mappings.get(lc + c):
      right_context = False
      print("OH NO!")
    # Otherwise, we only care about the first char (unigram) of the unfound bigram
    else:
      right_context = False
      if c == ' ':
        phones_out += c
      elif g2p_mappings.get(c):
        # For now, we will not worry about disambiguation, and just take the first phone
        phones_out += g2p_mappings.get(c)[0]
      else:
        print("COULDNT FIND A GRAPHEME FOR %s" % c)

  return phones_out

"""
  for bigram_tup in zip(chars, chars[1:]):
    # Assess bigram as a string to reflect the keys in the dict
    bigram = "".join(c for c in bigram_tup)
    if g2p_mappings.get(bigram):
      phones = g2p_mappings.get(bigram)
      # For now, we will not worry about disambiguation, and just take the first phone
      phones_out += phones[0]
    else: # Otherwise, we only care about the first char (unigram) of the unfound bigram
      uni = bigram[0]
      if uni == ' ':
        phones_out += uni
      elif g2p_mappings.get(uni):
        # For now, we will not worry about disambiguation, and just take the first phone
        phones_out += g2p_mappings.get(uni)[0]
      else:
        print("COULDNT FIND A GRAPHEME FOR %s" % uni)

  return phones_out

"""

consonants_dict = load_mappings(CONSONANTS)
vowels_dict = load_mappings(VOWELS)
g2p_mappings = consonants_dict
g2p_mappings.update(vowels_dict)

with codecs.open("./data/finnish-train-low", "r") as file:
  lines = [l.strip() for l in file]

  for line in lines:
    lemma, wf, tags = line.split("\t")
    print(lemma, wf)
    print("LEMMA: %s" % g2p(lemma, g2p_mappings))
    print("Word Form: %s" % g2p(wf, g2p_mappings))