# Exercise Looper API

API for managing questionnaires and their questions.

**OpenAPI:** `3.0.3`  
**Local server:** [http://localhost:9292](http://localhost:9292)

## Endpoints

| Method | Endpoint | Description |
| --- | --- | --- |
| `GET` | `/api/questionnaires` | Get all questionnaires |
| `POST` | `/api/questionnaires` | Create a questionnaire |
| `GET` | `/api/questionnaires/{id}` | Get a questionnaire by ID |
| `PUT` | `/api/questionnaires/{id}` | Update a questionnaire's status |
| `GET` | `/api/questions` | Get the questions belonging to a questionnaire |
| `POST` | `/api/questions` | Create a question |
| `PUT` | `/api/questions` | Update a question |

## Questionnaires

### Get all questionnaires

```http
GET /api/questionnaires
```

#### Successful response — `200 OK`

```json
{
  "questionnaires": [
    {
      "questionnaire_id": 1,
      "title": "General knowledge",
      "status": "editing"
    },
    {
      "questionnaire_id": 2,
      "title": "Ruby basics",
      "status": "answering"
    },
    {
      "questionnaire_id": 3,
      "title": "SQL basics",
      "status": "closed"
    },
    {
      "questionnaire_id": 4,
      "title": "TEST_PEDRO_SILVA",
      "status": "answering"
    }
  ]
}
```

### Create a questionnaire

```http
POST /api/questionnaires
Content-Type: application/json
```

#### Request body

```json
{
  "title": "Ruby basics"
}
```

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `title` | string | Yes | Questionnaire title; cannot be empty |

#### Successful response — `201 Created`

```json
{
  "message": "Questionnaire Ruby basics created"
}
```

### Get a questionnaire by ID

```http
GET /api/questionnaires/{id}
```

| Parameter | Location | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `id` | Path | integer | Yes | Questionnaire ID; minimum value: `1` |

#### Successful response — `200 OK`

```json
{
  "questionnaire_id": 1,
  "title": "General knowledge",
  "status": "editing"
}
```

### Update a questionnaire's status

```http
PUT /api/questionnaires/{id}
Content-Type: application/json
```

| Parameter | Location | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `id` | Path | integer | Yes | Questionnaire ID; minimum value: `1` |

#### Request body

```json
{
  "status": "answering"
}
```

The accepted status values are:

- `editing`
- `answering`
- `closed`

#### Successful response — `201 Created`

```json
{
  "message": "Questionnaire 1 UPDATED, status is now answering"
}
```

## Questions

### Get questions by questionnaire

```http
GET /api/questions
Content-Type: application/json
```

#### Request body

```json
{
  "questionnaire_id": 1
}
```

#### Successful response — `200 OK`

```json
{
  "questions": [
    {
      "question_id": 1,
      "question_text": "What is a Ruby block?",
      "questionnaire_id": 1,
      "question_type_id": 1
    }
  ]
}
```

### Create a question

```http
POST /api/questions
Content-Type: application/json
```

#### Request body

```json
{
  "questionnaire_id": 1,
  "question_text": "What is a Ruby block?",
  "question_type_id": 1
}
```

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `questionnaire_id` | integer | Yes | Parent questionnaire ID; minimum value: `1` |
| `question_text` | string | Yes | Question text; cannot be empty |
| `question_type_id` | integer | Yes | Question type ID; minimum value: `1` |

#### Successful response — `201 Created`

```json
{
  "message": "Question What is a Ruby block? created"
}
```

### Update a question

```http
PUT /api/questions
Content-Type: application/json
```

#### Request body

```json
{
  "question_id": 1,
  "questionnaire_id": 1,
  "question_text": "Explain what a Ruby block is.",
  "question_type_id": 1
}
```

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `question_id` | integer | Yes | Question ID; minimum value: `1` |
| `questionnaire_id` | integer | Yes | Parent questionnaire ID; minimum value: `1` |
| `question_text` | string | Yes | Updated question text; cannot be empty |
| `question_type_id` | integer | Yes | Question type ID; minimum value: `1` |

#### Successful response — `200 OK`

```json
{
  "message": "Question Explain what a Ruby block is. UPDATED"
}
```

## Data models

### Questionnaire

| Field | Type | Description |
| --- | --- | --- |
| `questionnaire_id` | integer | Unique questionnaire ID |
| `title` | string | Questionnaire title |
| `status` | string | `editing`, `answering`, or `closed` |

### Question

| Field | Type | Description |
| --- | --- | --- |
| `question_id` | integer | Unique question ID |
| `question_text` | string | Question text |
| `questionnaire_id` | integer | Parent questionnaire ID |
| `question_type_id` | integer | Question type ID |

## Error response

An unknown route returns `404 Not Found`:

```json
{
  "message": "Route not found"
}
```
