#! /bin/bash
#Preproceses, generates files, and trains on the data
# This uses epitran G2P

ROOT="$1"
LANG="$2"

# Format the dev files, and get the g2p
python "$ROOT"/phone-based-reinflection/scripts/conll2onmt_PHONOLOGICAL_FEATURES.py "$LANG" "$ROOT"/phone-based-reinflection/data/"$LANG"-dev "$ROOT"/phone-based-reinflection/data/onmt-phone-feature-inputs/"$LANG"-dev

# Try all settings
for s in low medium high;
do
  # Format the train data, and get the g2p
  python "$ROOT"/phone-based-reinflection/scripts/conll2onmt_PHONOLOGICAL_FEATURES.py "$LANG" "$ROOT"/phone-based-reinflection/data/"$LANG"-train-"$s" "$ROOT"/phone-based-reinflection/data/onmt-phone-feature-inputs/"$LANG"-train-"$s"
  # Preprocess and train an ONMT model on files formatted above
  python "$ROOT"/OpenNMT-py/preprocess.py -train_src  "$ROOT"/phone-based-reinflection/data/onmt-phone-feature-inputs/"$LANG"-train-"$s"-src.txt -train_tgt  "$ROOT"/phone-based-reinflection/data/onmt-phone-feature-inputs/"$LANG"-train-"$s"-tgt.txt -valid_src  "$ROOT"/phone-based-reinflection/data/onmt-phone-feature-inputs/"$LANG"-dev-src.txt -valid_tgt  "$ROOT"/phone-based-reinflection/data/onmt-phone-feature-inputs/"$LANG"-dev-tgt.txt -save_data "$ROOT"/phone-based-reinflection/reinflection-phoneme-models/"$LANG"-phone-features-"$s"
  # Added arg to only save last (50th) model
  python "$ROOT"/OpenNMT-py/train.py -data "$ROOT"/phone-based-reinflection/reinflection-phoneme-models/"$LANG"-phone-features-"$s" -save_model "$ROOT"/phone-based-reinflection/reinflection-phoneme-models/"$LANG"-phone-features-"$s"-model -epochs 50 -brnn -start_checkpoint_at 50 -gpuid 0
done;
