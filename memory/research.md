# Technical Report: Analysis of the `rankNet_bert` Project

This report provides a technical overview of the `rankNet_bert` project, intended for new engineers tasked with its maintenance and development. The analysis is based on a review of the project's source code and existing documentation.

## 1. Project Overview

The `rankNet_bert` project is a "learning-to-rank" system designed to score and sort Steam game reviews. It utilizes a `hfl/rbt3` BERT model, fine-tuned using a RankNet architecture, to predict the relative quality of reviews (C1). The intended workflow is to train the model on pairs of reviews and then use the trained model to assign an absolute score to new, unseen reviews for ranking purposes (E2, E6).

## 2. Key Findings and Critical Issues

While the project presents an interesting approach to review ranking, a new engineer must be aware of several fundamental issues that prevent it from being a functional or reliable system in its current state.

### 2.1 The Project is Not Executable

The most immediate issue is that the project's core scripts, `index.py` (training) and `eval.py` (evaluation), are not runnable. They depend on data from `./dataset/training/` and `./dataset/validation/` directories, and a `./checkpoint/` directory for saving and loading models. None of these directories or the required data exist in the repository, making the described workflow purely theoretical (C3).

### 2.2 The Data Pipeline is Fragile and Biased

The project's entire training and evaluation process is critically dependent on a manual, non-reproducible data collection method (C4).

*   **Manual Data Extraction:** Data is sourced by manually executing JavaScript snippets (`getTrainData.js`, `getValidationData.js`) in a web browser's developer console on Steam review pages (E7). This process is fragile, undocumented, and prone to breaking with any change in Steam's front-end.

*   **Embedded Bias:** The training data is not a neutral representation of review helpfulness. The `getTrainData.js` script implements a highly opinionated custom scoring algorithm that pre-sorts the data before it is even fed to the model (E10). This algorithm introduces significant developer bias. For example, it actively penalizes reviews containing a specific cat-related meme (`/(?:貓|猫).*(?:讚|赞).*摸/`).

**The consequence is that the model does not learn a general standard of review quality. Instead, it learns to replicate the developer's specific and arbitrary biases as encoded in the data-gathering script (C7).**

### 2.3 Architectural Flaws and Technical Debt

Several architectural choices compromise the project's validity and maintainability.

*   **Training vs. Evaluation Mismatch:** There is a fundamental mismatch between the training and evaluation methodologies. The model is trained on *pairs* of reviews to learn relative ranking (a pair-wise approach), but it is evaluated by assigning an independent, absolute score to each review (a point-wise approach). The validity of using a pair-wise trained model for point-wise scoring is not established or justified within the project (C8).

*   **Code Duplication:** The `RankNet` PyTorch class is defined identically in both `index.py` and `eval.py` (E8). This code redundancy creates technical debt and increases the risk of inconsistencies, as a change in one file might not be propagated to the other (C5).

## 3. Recommendations for a New Engineer

To move this project from a broken proof-of-concept to a maintainable and meaningful system, the following actions are recommended:

1.  **Establish a Data Baseline:** Before running any code, you must create the necessary directory structure (`dataset/training`, `dataset/validation`, `checkpoint`). You will need to acquire or generate the JSON data files that the scripts depend on (related to C3).

2.  **Build a Reproducible Data Pipeline:** The manual JavaScript-based data collection should be replaced with a robust, automated solution. This could be a dedicated scraping script (e.g., using Python with libraries like `requests` or `BeautifulSoup`) that fetches data directly from Steam's public APIs or web pages (related to C4).

3.  **Redefine the Training Goal:** The current biased training methodology must be abandoned. The model should be trained on objective, verifiable data, such as the raw "helpful" and "funny" counts provided by Steam. The goal should be to predict user-perceived quality, not to enforce a developer's personal preferences (related to C7).

4.  **Align Training and Evaluation:** The methodological mismatch between training and evaluation needs to be resolved. Either the evaluation should be changed to compare pairs of reviews, or the model and training process should be redesigned for a point-wise scoring task (related to C8).

5.  **Refactor the Codebase:** To improve maintainability, the duplicated `RankNet` class should be moved to a shared utility file and imported into both `index.py` and `eval.py` (related to C5).
