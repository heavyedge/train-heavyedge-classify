# Train HeavyEdge-Classify

Repository to train [HeavyEdge-Classify](https://pypi.org/project/heavyedge-classify/) model and upload to HuggingFace.

## Setup

```
pip install -r requirements.txt
gdown --fuzzy [google drive link] -O dataset.tar
```

## Preprocessing

```
mkdir -p _data
tar -xf dataset.tar -C _data
make _temp/MeanProfiles.h5
```
