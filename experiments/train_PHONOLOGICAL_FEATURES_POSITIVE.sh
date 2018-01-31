#! /bin/bash
# Preproceses, generates files, and trains on the data
# This uses epitran G2P

ROOT="$1"
LANG="$2"

# Format the dev files, and get the g2p
python "$ROOT"/phone-based-reinflection/scripts/conll2onmt_POSITIVE_PHONOLOGICAL_FEATURES.py "$LANG" "$ROOT"/phone-based-reinflection/data/"$LANG"-dev "$ROOT"/phone-based-reinflection/data/onmt-positive-phone-feature-inputs/"$LANG"-dev

# just high setting
s=high
# Format the train data, and get the g2p
python "$ROOT"/phone-based-reinflection/scripts/conll2onmt_POSITIVE_PHONOLOGICAL_FEATURES.py "$LANG" "$ROOT"/phone-based-reinflection/data/"$LANG"-train-"$s" "$ROOT"/phone-based-reinflection/data/onmt-positive-phone-feature-inputs/"$LANG"-train-"$s"
# Preprocess and train an ONMT model on files formatted above
python "$ROOT"/OpenNMT-py/preprocess.py -train_src  "$ROOT"/phone-based-reinflection/data/onmt-positive-phone-feature-inputs/"$LANG"-train-"$s"-src.txt -train_tgt  "$ROOT"/phone-based-reinflection/data/onmt-positive-phone-feature-inputs/"$LANG"-train-"$s"-tgt.txt -valid_src  "$ROOT"/phone-based-reinflection/data/onmt-positive-phone-feature-inputs/"$LANG"-dev-src.txt -valid_tgt  "$ROOT"/phone-based-reinflection/data/onmt-positive-phone-feature-inputs/"$LANG"-dev-tgt.txt -save_data "$ROOT"/phone-based-reinflection/reinflection-phonological-feature-models/"$LANG"-phone-features-positive-"$s"
# Added arg to only save last (50th) model
python "$ROOT"/OpenNMT-py/train.py -data "$ROOT"/phone-based-reinflection/reinflection-phonological-feature-models/"$LANG"-phone-features-positive-"$s" -save_model "$ROOT"/phone-based-reinflection/reinflection-phonological-feature-models/"$LANG"-phone-features-positive-"$s"-model -epochs 50 -encoder_type brnn -start_checkpoint_at 49 -gpuid 0
