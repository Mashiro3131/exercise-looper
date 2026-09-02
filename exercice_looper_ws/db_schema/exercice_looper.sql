DROP DATABASE IF EXISTS exercice_looper_db;
CREATE DATABASE IF NOT EXISTS exercice_looper_db;
USE exercice_looper_db;


CREATE TABLE questionnaires (
    questionnaire_id INT AUTO_INCREMENT,
    title            VARCHAR(255) NOT NULL,
    status           ENUM('editing', 'answering', 'closed') NOT NULL DEFAULT 'editing',

    CONSTRAINT pk_questionnaires PRIMARY KEY (questionnaire_id),
    CONSTRAINT chk_questionnaires_title
    CHECK (CHAR_LENGTH(TRIM(title)) > 0)
);


CREATE TABLE question_types
(
    question_type_id INT AUTO_INCREMENT,
    description      VARCHAR(255) NOT NULL,
    CONSTRAINT pk_question_types PRIMARY KEY (question_type_id),
    CONSTRAINT uq_question_types_description UNIQUE (description),
    CONSTRAINT chk_question_types_description CHECK (CHAR_LENGTH(TRIM(description)) > 0)
);


CREATE TABLE questions
(
    question_id      INT AUTO_INCREMENT,
    question_text    VARCHAR(255) NOT NULL,
    questionnaire_id INT NOT NULL,
    question_type_id INT NOT NULL,
    CONSTRAINT pk_questions PRIMARY KEY (question_id),
    CONSTRAINT chk_questions_text CHECK (CHAR_LENGTH(TRIM(question_text)) > 0),
    CONSTRAINT fk_questions_questionnaire FOREIGN KEY (questionnaire_id) REFERENCES questionnaires (questionnaire_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_questions_question_type FOREIGN KEY (question_type_id) REFERENCES question_types (question_type_id) ON UPDATE CASCADE ON DELETE RESTRICT
);