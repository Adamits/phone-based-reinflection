#! /bin/sh

ROOT="$1"
MODEL="$2"
LANG="$3"
SETTING="$4"

python "$ROOT"/phone-based-reinflection/scripts/conll2onmt.py "$ROOT"/phone-based-reinflection/data/"$LANG"-train-"$SETTING" "$ROOT"/phone-based-reinflection/onmt-character-inputs
python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/phone-based-reinflection/onmt-character-inputs/"$LANG"-train-"$SETTING"-src.txt -tgt "$ROOT"/phone-based-reinflection/onmt-character-inputs/"$LANG"-train-"$SETTING"-tgt.txt  -output "$ROOT"/phone-based-reinflection/onmt-phone-inputs/"$LANG"-"$SETTING" -replace_unk