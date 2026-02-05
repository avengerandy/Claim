- id: C1
  statement: The `rankNet_bert` project implements a learning-to-rank system for Steam game reviews. It uses a BERT-based model (`hfl/rbt3`) fine-tuned with a RankNet architecture to score and sort reviews.
  based_on:
    - E1
    - E3
    - E4
    - E5
    - E6
    - E9
  confidence: high
- id: C2
  statement: The project's workflow involves first scraping review data from Steam using the provided JavaScript snippets, then using that data to fine-tune the `hfl/rbt3` model and train the RankNet architecture with `index.py`, and finally using `eval.py` to rank a new set of reviews with the fine-tuned model.
  based_on:
    - E2
    - E3
    - E6
    - E7
    - E9
  confidence: high
- id: C3
  statement: The workflow described in C2 is theoretical and not currently executable. The Python scripts (`index.py`, `eval.py`) depend on data from `./dataset/training/` and `./dataset/validation/` and a `./checkpoint/` directory for saving/loading models, none of which exist in the repository.
  based_on:
    - C2
    - E3
    - E6
  confidence: high
  notes: "Attacks C2 by highlighting that the described workflow is broken due to missing data and directories. The project is not in a runnable state."
- id: C4
  statement: The project's reliance on manually executing JavaScript in a browser console for data collection (E7) makes the data pipeline fragile and not reproducible. The workflow in C2 is critically dependent on an external, manual process that could easily break.
  based_on:
    - C2
    - E7
  confidence: high
  notes: "Attacks C2 by pointing out the unreliability and manual nature of the data source, which undermines the entire workflow's robustness."
- id: C5
  statement: The duplication of the `RankNet` class definition across `index.py` and `eval.py` introduces technical debt, making the codebase harder to maintain and prone to inconsistencies.
  based_on:
    - E8
  confidence: high
- id: C6
  statement: The training data for the RankNet model is not based on the raw helpfulness scores from Steam, but is instead pre-processed and sorted by a highly opinionated and custom scoring algorithm. This algorithm introduces biases, such as penalizing reviews containing specific phrases (a cat-related meme), which will be learned by the final model.
  based_on:
    - E10
    - E7
  confidence: high
- id: C7
  statement: The model does not learn to rank reviews based on a general standard of quality, but rather learns to replicate the developer's specific and arbitrary biases, such as penalizing certain memes, as encoded in the 'getTrainData.js' script.
  based_on:
    - C1
    - C6
    - E10
  confidence: high
- id: C8
  statement: There is a fundamental mismatch between the training and evaluation methods. The model is trained on pairs of reviews using a ranking loss (pair-wise), but it is evaluated by assigning an independent score to each review (point-wise). The validity of using a pair-wise trained model for point-wise scoring is not established.
  based_on:
    - C1
    - E5
    - E6
  confidence: medium

