#! /bin/sh
#Preproceses, generates files, and trains on the data

ROOT="$1"
LANG="finnish"
LANG_CODE="fin"
EPOCHS="50"

python "$ROOT"/phone-based-reinflection/scripts/phoible2onmt.py -i "$ROOT"/phone-based-reinflection/data/pron_data/gold_data_train -o "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data -l $LANG -lc $LANG_CODE
python "$ROOT"/OpenNMT-py/preprocess.py -train_src  "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/$LANG-train-src -train_tgt  "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/$LANG-train-tgt -valid_src  "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/$LANG-dev-src -valid_tgt  "$ROOT"/phone-based-reinflection/data/opennmt-formatted-pron_data/$LANG-dev-tgt -save_data "$ROOT"/phone-based-reinflection/g2p-models/$LANG
python "$ROOT"/OpenNMT-py/train.py -data "$ROOT"/phone-based-reinflection/g2p-models/$LANG -save_model "$ROOT"/phone-based-reinflection/g2p-models/$LANG -epochs "$EPOCHS" -brnn  -word_vec_size 500 -rnn_size 500 -gpuid 0