- id: E1
  description: The project uses `pytorch` for machine learning, specifically `torch==2.3.1+cu121`. It also uses the `transformers` library from Hugging Face. The model is based on `hfl/rbt3`.
  source:
    - app/rankNet_bert/requirements.txt
    - app/rankNet_bert/pytorchRequirements.txt
    - app/rankNet_bert/index.py
  confidence: high
- id: E2
  description: The project contains two main Python scripts, `index.py` for training and `eval.py` for evaluation.
  source:
    - app/rankNet_bert/index.py
    - app/rankNet_bert/eval.py
  confidence: high
- id: E3
  description: The training process in `index.py` loads review data from JSON files in `./dataset/training/`, tokenizes them, creates positive pairs, and trains a `RankNet` model. The trained model (`rbt3` and `RankNet` state dict) is saved to the `./checkpoint/` directory.
  source:
    - app/rankNet_bert/index.py
  confidence: high
- id: E4
  description: The `RankNet` model is a simple neural network with a single linear layer on top of the pooled output of the `rbt3` transformer model. It outputs a single score.
  source:
    - app/rankNet_bert/index.py
    - app/rankNet_bert/eval.py
  confidence: high
- id: E5
  description: The training loss function is `nn.BCEWithLogitsLoss`, which is used on the difference between the scores of two inputs (`score1 - score2`). This is characteristic of a learning-to-rank approach where the goal is to predict which item should have a higher score.
  source:
    - app/rankNet_bert/index.py
  confidence: high
- id: E6
  description: The `eval.py` script loads a trained `RankNet` model and the `rbt3` model from the `./checkpoint/` directory. It then reads reviews from a validation JSON file (`./dataset/validation/女神異聞錄3.json`), scores each review using the model, and prints them in descending order of score.
  source:
    - app/rankNet_bert/eval.py
  confidence: high
- id: E7
  description: The project includes JavaScript files (`getTrainData.js`, `getValidationData.js`) in the `dataset` directory. These scripts appear to be designed to be run in a web browser's developer console on a Steam store page to extract review data. `getTrainData.js` scrapes review text, helpfulness counts, and applies a custom scoring and sorting algorithm before downloading the data as a JSON file. `getValidationData.js` scrapes review text.
  source:
    - app/rankNet_bert/dataset/getTrainData.js
    - app/rankNet_bert/dataset/getValidationData.js
  confidence: high
- id: E8
  description: The `RankNet` class definition is duplicated in both `app/rankNet_bert/index.py` and `app/rankNet_bert/eval.py`. This leads to code redundancy and potential inconsistencies if changes are made to one but not the other.
  source:
    - app/rankNet_bert/index.py
    - app/rankNet_bert/eval.py
  confidence: high
  notes: "Identified during code exploration to understand project structure."
- id: E9
  description: The `rbt3` model is loaded from `'hfl/rbt3'` (Hugging Face model hub) in `index.py` for training, but from `'./checkpoint/rbt3'` in `eval.py` for evaluation. This indicates an intended workflow where `hfl/rbt3` is fine-tuned during training and the fine-tuned model is saved and then used for evaluation.
  source:
    - app/rankNet_bert/index.py
    - app/rankNet_bert/eval.py
  confidence: high
- id: E10
  description: The 'getTrainData.js' script calculates a custom score for each scraped Steam review to sort the data before it is used for training. This score is based on a formula involving the log of the review length, the ratio of 'helpful' to 'funny' votes, a decay factor based on the review's original order, and a penalty if the review text matches the regex '/(?:貓|猫).*(?:讚|赞).*摸/' (a phrase related to praising cats).
  source:
    - app/rankNet_bert/dataset/getTrainData.js
  confidence: high

