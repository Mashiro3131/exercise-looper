
USE exercice_looper_db;

CREATE TABLE answers (
    answer_id INT AUTO_INCREMENT,
    submission_id INT,
    question_id INT NOT NULL,
    answer_text TEXT,

    CONSTRAINT pk_answers
        PRIMARY KEY (answer_id),

    CONSTRAINT uq_answers_submission_question
        UNIQUE (submission_id, question_id),

    CONSTRAINT fk_answers_question
        FOREIGN KEY (question_id)
        REFERENCES questions(question_id)
        ON DELETE CASCADE
);
