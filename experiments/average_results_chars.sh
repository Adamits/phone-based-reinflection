#! /bin/bash

ROOT="$1"

# Loop over every lang that is in the SIGMORPHON data, AND that epitran supports
for l in bengali catalan dutch english french german hindi hungarian italian kurmanji persian polish portuguese russian sorani spanish swedish ukranian; do
  python "$ROOT"/phone-based-reinflection/scripts/conll2onmt.py "$ROOT"/phone-based-reinflection/data/"$l"-dev "$ROOT"/phone-based-reinflection/average_char_inputs

  # Format the train data
  python "$ROOT"/phone-based-reinflection/scripts/conll2onmt.py "$ROOT"/phone-based-reinflection/data/"$l"-train-high "$ROOT"/phone-based-reinflection/average_char_inputs
  # Preprocess and train an ONMT model on files formatted above
  python "$ROOT"/OpenNMT-py/preprocess.py -train_src  "$ROOT"/phone-based-reinflection/average_char_inputs/"$l"-train-high-src.txt -train_tgt  "$ROOT"/phone-based-reinflection/average_char_inputs/"$l"-train-high-tgt.txt -valid_src  "$ROOT"/phone-based-reinflection/average_char_inputs/"$l"-dev-src.txt -valid_tgt  "$ROOT"/phone-based-reinflection/average_char_inputs/"$l"-dev-tgt.txt -save_data "$ROOT"/phone-based-reinflection/average_char_models/"$l"-high
  python "$ROOT"/OpenNMT-py/train.py -data "$ROOT"/phone-based-reinflection/average_char_models/"$l"-high -save_model "$ROOT"/phone-based-reinflection/average_char_models/"$l"-high-model -epochs 50 -start_checkpoint_at 50 -encoder_type brnn -gpuid 0
done;


# Now test the models from above
for l in bengali catalan dutch english french german hindi hungarian italian kurmanji persian polish portuguese russian sorani spanish swedish ukranian; do
  # Find the PATH to the (unique) model from the training above, per language
  MODEL="$(echo "$ROOT"/phone-based-reinflection/average_char_models/"$l"-high-model_acc*.pt)"

  # Format the test data
  python "$ROOT"/phone-based-reinflection/scripts/conll2onmt.py "$ROOT"/phone-based-reinflection/data/"$l"-uncovered-test "$ROOT"/phone-based-reinflection/average_char_inputs

  python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/phone-based-reinflection/average_char_inputs/"$l"-test-src.txt -tgt "$ROOT"/phone-based-reinflection/average_char_inputs/"$l"-test-tgt.txt  -output "$ROOT"/phone-based-reinflection/average_char_preds/"$l"-pred.txt -replace_unk

  ACC=$(python "$ROOT"/phone-based-reinflection/scripts/evalm.py --gold "$ROOT"/phone-based-reinflection/average_char_inputs/"l"-test-tgt.txt --guess "$ROOT"/phone-based-reinflection/average_char_preds/"$l"-pred.txt)
  ACCFILE="$ROOT"/phone-based-reinflection/average_accuracies/char.acc

  echo "$LANG: $ACC" >> "$ACCFILE"
done;

python "$ROOT"/phone-based-reinflection/scripts/calculate_total_accuracies.py "$ROOT"/phone-based-reinflection/average_accuracies/chars.acc