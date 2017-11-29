#! /bin/sh

ROOT="$1"
LANG="finnish"

for s in low medium high;
do
    /bin/bash "$ROOT"/phone-based-reinflection/scripts/get_g2p_test.sh $ROOT $ROOT/phone-based-reinflection/g2p-models/finnish_acc_96.28_ppl_1.18_e20.pt $LANG $s
    python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/finnish-test-src -tgt "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/finnish-test-tgt  -output "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/"$MODEL_FN"-pred.txt -replace_unk
    python "$ROOT"/phone-based-reinflection/scripts/evalm.py --gold "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/finnish-test-tgt --guess "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/"$MODEL_FN"-pred.txt
done;
