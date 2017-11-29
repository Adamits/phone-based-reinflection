#! /bin/bash

ROOT="$1"
MODEL="$2"
LANG="$3"
SETTING="$4"

python "$ROOT"/phone-based-reinflection/scripts/conll2onmt_PHONES.py "$ROOT"/phone-based-reinflection/data/"$LANG"-uncovered-test "$ROOT"/phone-based-reinflection/data/onmt-character-inputs
# Just set tgt to itself for each, as we simply want to translate our raw inputs, and have no gold data
python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-uncovered-test-lemmas.txt -tgt "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-uncovered-test-lemmas.txt  -output "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-uncovered-test-lemmas -replace_unk
python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-uncovered-test-word_forms.txt -tgt "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-uncovered-test-word_forms.txt  -output "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-uncovered-test-word_forms -replace_unk
python "$ROOT"/phone-based-reinflection/scripts/phone_inputs2onmt.py "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-uncovered-test "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/