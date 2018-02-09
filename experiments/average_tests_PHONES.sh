#! /bin/bash

ROOT="$1"

for l in bengali catalan dutch english french german hindi hungarian italian kurmanji persian polish portuguese russian sorani spanish swedish ukrainian; do
  ACC=$(python "$ROOT"/phone-based-reinflection/scripts/evalm.py --gold "$ROOT"/phone-based-reinflection/average_PHONE_inputs/"$l"-uncovered-test-tgt.txt --guess "$ROOT"/phone-based-reinflection/average_PHONE_preds/"$l"-pred.txt)
  ACCFILE="$ROOT"/phone-based-reinflection/average_accuracies/PHONE.acc

  echo "$l: $ACC" >> "$ACCFILE"
done;

python "$ROOT"/phone-based-reinflection/scripts/calculate_total_accuracies.py "$ROOT"/phone-based-reinflection/average_accuracies/PHONE.acc
