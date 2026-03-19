.ONESHELL:

DATASETS := $(shell ls -d _data/dataset* | sed -E 's|^[^/]*/||')

.PHONY: all test

all: model/classify-model.pkl test

test: _temp/label-pred.npy _temp/labels.npy
	python3 -c "import numpy as np; assert np.load('$(word 1,$^)').shape[1] == len(np.unique(np.load('$(word 2,$^)')))"

_temp/MeanProfiles.h5: $(foreach dataset, $(DATASETS), _data/$(dataset)/MeanProfiles.h5)
	mkdir -p $(@D)
	heavyedge merge $^ -o $@

_temp/knees.csv: $(foreach dataset, $(DATASETS), _data/$(dataset)/knees.csv)
	python3 -c "import pandas as pd; dfs = [pd.read_csv(path) for path in '$^'.split()]; pd.concat(dfs)[['Type']].to_csv('$@', index=False)"

_temp/canonical.csv: $(foreach dataset, $(DATASETS), _data/$(dataset)/canonical.csv)
	python3 -c "import pandas as pd; dfs = [pd.read_csv(path) for path in '$^'.split()]; pd.concat(dfs)[['Type']].to_csv('$@', index=False)"

_temp/labels.npy: write-labels.py _temp/knees.csv _temp/canonical.csv
	python3 $^ -o $@

model/classify-model.pkl: _temp/MeanProfiles.h5 _temp/labels.npy
	mkdir -p $(@D)
	heavyedge --log-level=INFO classify-train --n-splits 5 --random-state 0 $^ -o $@

_temp/label-pred.npy: _temp/MeanProfiles.h5 model/classify-model.pkl
	heavyedge --log-level=INFO classify-predict --batch-size 10 $^ -o $@
