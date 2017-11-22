#! /bin/sh

ROOT="$1"
MODEL="$2"
LANG="finnish"
LANG_CODE="fin"
MODEL_FN="$(basename $MODEL)"

python "$ROOT"/phone-based-reinflection/scripts/phoible2onmt_testfiles.py -i "$ROOT"/phone-based-reinflection/data/pron_data/gold_data_test -o "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data -l $LANG -lc $LANG_CODE
python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/finnish-test-src -tgt "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/finnish-test-tgt  -output "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/"$MODEL_FN"-pred.txt -replace_unk
