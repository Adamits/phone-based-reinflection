#! /bin/bash
#Preproceses, generates files, and trains on the data
#G2P Model must be hardcoded, and is assumed to have already been trained

ROOT="$1"
LANG="finnish"

for s in low medium high;
do
  /bin/bash "$ROOT"/phone-based-reinflection/scripts/get_g2p_train.sh $ROOT $ROOT/phone-based-reinflection/g2p-models/finnish_acc_96.28_ppl_1.18_e20.pt $LANG $s
  python "$ROOT"/OpenNMT-py/preprocess.py -train_src  "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-train-"$s"-src.txt -train_tgt  "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-train-"$s"-tgt.txt -valid_src  "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-dev-src.txt -valid_tgt  "$ROOT"/phone-based-reinflection/data/onmt-phone-inputs/"$LANG"-dev-tgt.txt -save_data "$ROOT"/phone-based-reinflection/reinflection-phoneme-models/"$LANG"-"$s"
  python "$ROOT"/OpenNMT-py/train.py -data "$ROOT"/phone-based-reinflection/reinflection-phoneme-models/"$LANG"-"$s" -save_model "$ROOT"/phone-based-reinflection/reinflection-phoneme-models/"$LANG"-"$s"-model -epochs 50 -encoder_type brnn -gpuid 0
done;
