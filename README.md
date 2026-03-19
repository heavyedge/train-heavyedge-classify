# Train HeavyEdge-Classify

Repository to train [HeavyEdge-Classify](https://pypi.org/project/heavyedge-classify/) model and upload to HuggingFace.

## Download profile data

```
curl -LsSf https://hf.co/cli/install.sh | bash
hf auth login --token [Huggingface Token]
hf download jeesoo9595/heavyedge-dataset-v1 --repo-type dataset --revision v1.0.0 --include "dataset.tar.gz" --local-dir .
mkdir -p _data
tar -xzf dataset.tar.gz -C _data
```

## Download label data

```
pip install gdown
gdown --fuzzy [google drive link] -O labels.tar
tar -xf labels.tar -C _data
```

## Train & test

```
pip install -r requirements.txt
make model/classify-model.pkl
make test
```
