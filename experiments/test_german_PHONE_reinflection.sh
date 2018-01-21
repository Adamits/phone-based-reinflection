#! /bin/sh

ROOT="$1"
MODEL="$2"
LANG="german"
MODEL_FN="$(basename $MODEL)"

# Format the test data, and get the g2p
python "$ROOT"/phone-based-reinflection/scripts/conll2onmt-epitran_PHONES.py "$LANG" "$ROOT"/phone-based-reinflection/data/"$LANG"-uncovered-test "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-test

python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-test-src.txt -tgt "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-test-tgt.txt  -output "$ROOT"/phone-based-reinflection/preds/"$MODEL_FN"-pred.txt -replace_unk
python "$ROOT"/phone-based-reinflection/scripts/evalm.py --gold "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-test-tgt.txt --guess "$ROOT"/phone-based-reinflection/preds/"$MODEL_FN"-pred.txt
