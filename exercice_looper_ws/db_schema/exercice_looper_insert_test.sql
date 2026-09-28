INSERT INTO question_types (description) VALUES('Single line text'),('List of single lines'),    ('Multi-line text');


INSERT INTO questionnaires (title, status)
VALUES ('General knowledge', 'editing'),
       ('Ruby basics', 'answering'),
       ('SQL basics', 'closed');

INSERT INTO questions (question_text, questionnaire_id, question_type_id)
VALUES ('What is the capital of France?', 1, 1),
       ('Ruby is an object-oriented language.', 2, 2),
       ('What does a JOIN do in SQL?', 3, 3);
