#! /bin/sh

ROOT="$1"
MODEL="$2"
LANG="$3"
SETTING="$4"

python "$ROOT"/phone-based-reinflection/scripts/conll2onmt_PHONES.py "$ROOT"/phone-based-reinflection/data/"$LANG"-train-"$SETTING" "$ROOT"/phone-based-reinflection/data/onmt-character-inputs
python "$ROOT"/phone-based-reinflection/scripts/conll2onmt_PHONES.py "$ROOT"/phone-based-reinflection/data/"$LANG"-dev "$ROOT"/phone-based-reinflection/data/onmt-character-inputs
# Just set tgt to itself for each, as we simply want to translate our raw inputs, and have no gold data
python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-train-"$SETTING"-lemmas.txt -tgt "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-train-"$SETTING"-lemmas.txt  -output "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-train-"$SETTING"-lemmas -replace_unk
python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-train-"$SETTING"-word_forms.txt -tgt "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-train-"$SETTING"-word_forms.txt  -output "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-train-"$SETTING"-word_forms -replace_unk
python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-dev-lemmas.txt -tgt "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-dev-lemmas.txt  -output "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-dev-lemmas -replace_unk
python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-dev-word_forms.txt -tgt "$ROOT"/phone-based-reinflection/data/onmt-character-inputs/"$LANG"-dev-word_forms.txt  -output "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-dev-word_forms -replace_unk
python "$ROOT"/phone-based-reinflection/scripts/phone_inputs2onmt.py "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-train-"$SETTING" "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/
python "$ROOT"/phone-based-reinflection/scripts/phone_inputs2onmt.py "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-dev "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/