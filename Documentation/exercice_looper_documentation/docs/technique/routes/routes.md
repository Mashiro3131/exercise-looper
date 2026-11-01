# Exercise Looper — MVC Routes and Forms

Exercise Looper is a web application for creating questionnaires, managing their questions, and submitting or editing answers.

The application uses an MVC structure with Ruby controllers and server-rendered views. The routes documented here render HTML pages, process form submissions, or redirect the browser.

**Local server:** [http://localhost:9292](http://localhost:9292)

## Application structure

| Component | Responsibility |
| --- | --- |
| Router | Match the request path and HTTP method, then dispatch to a controller action |
| Controllers | Read request parameters, call services, and select a view or redirect |
| Services | Perform application operations using repositories |
| Repositories | Read and write persistent data |
| Views | Render the HTML pages and forms returned to the browser |

The router uses `Route` for fixed paths and `DynamicRoute` for paths containing identifiers. If no route matches, it calls `QuestionnairesController#not_found`, which renders the `404` view with HTTP status `404`.

## Routes overview

The parameter names below distinguish questionnaire IDs from question IDs. In the supplied router, these are both written as `:id` in the question editing and deletion routes. The table keeps the same URL structure while making each position explicit.

| Method | Route | Controller action | Purpose |
| --- | --- | --- | --- |
| `GET` | `/` | `QuestionnairesController#home` | Display the home page |
| `GET` | `/exercises` | `QuestionnairesController#index` | Display all questionnaires |
| `GET` | `/exercises/new` | `QuestionnairesController#new` | Display the questionnaire creation form |
| `POST` | `/exercises` | `QuestionnairesController#create` | Create a questionnaire |
| `PUT` | `/exercises/:questionnaire_id` | `QuestionnairesController#update_status` | Update a questionnaire's status |
| `GET` | `/exercises/:questionnaire_id/fields` | `QuestionsController#fields` | Display a questionnaire's questions |
| `POST` | `/exercises/:questionnaire_id/fields` | `QuestionsController#create_field` | Create a question |
| `GET` | `/exercises/:questionnaire_id/fields/:question_id/edit` | `QuestionsController#get_field_by_id` | Display the question editing form |
| `PUT` | `/exercises/:questionnaire_id/fields/:question_id` | `QuestionsController#edit_field` | Update a question |
| `DELETE` | `/exercises/:questionnaire_id/fields/:question_id` | `QuestionsController#delete_field` | Delete a question |
| `GET` | `/exercises/answering` | `AnswersController#index` | Display questionnaires open for answers |
| `GET` | `/exercises/:questionnaire_id/fulfillments/new` | `AnswersController#new` | Display a new answer form |
| `POST` | `/exercises/:questionnaire_id/fulfillments` | `AnswersController#create` | Save a new submission |
| `GET` | `/exercises/:questionnaire_id/fulfillments/:submission_id/edit` | `AnswersController#edit` | Display a saved submission for editing |
| `PUT` | `/exercises/:questionnaire_id/fulfillments/:submission_id` | `AnswersController#update` | Update a saved submission |

## Request and response conventions

### Path parameters

| Parameter | Description | Example |
| --- | --- | --- |
| `questionnaire_id` | Identifies the questionnaire | `/exercises/1/fields` |
| `question_id` | Identifies a question within the route | `/exercises/1/fields/3/edit` |
| `submission_id` | Identifies a saved answer submission | `/exercises/1/fulfillments/7/edit` |

`QuestionnairesController` and `AnswersController` extract identifiers from `@request.path_info`. These path segments are strings when read by the controllers.

### Form parameters

The supplied controllers read form values from `@request.params`. Examples of HTML field names and the corresponding Ruby accessors are:

| HTML field name | Ruby accessor |
| --- | --- |
| `exercise[title]` | `@request.params["exercise"]["title"]` |
| `exercise[status]` | `@request.params["exercise"]["status"]` |
| `answers[3]` | `@request.params["answers"]["3"]` |

The examples below use form submissions rather than JSON request bodies.

### PUT and DELETE from HTML forms

For `PUT` and `DELETE` routes, an HTML form can submit with `method="post"` and include a hidden `_method` field, provided method override is enabled in the Rack application.

```html
<input type="hidden" name="_method" value="put">
```

Use `value="delete"` for deletion. The router must receive the resulting `PUT` or `DELETE` method for the corresponding route to match.

### Responses

Page actions render HTML views. Successful write actions in the supplied questionnaire and answer controllers redirect to another application route.

The exact success status codes for `view` and `redirect` depend on the `BaseController` implementation, which is not included here. Explicit error codes shown in the supplied controllers are documented below.

## Home page

### Display the home page

```http
GET /
```

**Controller:** `QuestionnairesController#home`

**View:** `index`

## Questionnaires

### List all questionnaires

```http
GET /exercises
```

**Controller:** `QuestionnairesController#index`

The controller fetches all questionnaires, converts each questionnaire's keys to strings, and passes the collection to the view.

**View:** `exercises/index`

**View data:** `questionnaires`

### Display the creation form

```http
GET /exercises/new
```

**Controller:** `QuestionnairesController#new`

**View:** `exercises/new`

### Create a questionnaire

```http
POST /exercises
Content-Type: application/x-www-form-urlencoded

exercise[title]=Ruby+basics
```

**Controller:** `QuestionnairesController#create`

| Form field | Description |
| --- | --- |
| `exercise[title]` | Title passed to `QuestionnairesService#create_questionnaire` |

The service returns the new questionnaire ID. The controller then redirects to its question management page.

**Redirect:** `/exercises/:questionnaire_id/fields`

For example, creating questionnaire `5` redirects to `/exercises/5/fields`.

Title validation and the initial status are not defined in the supplied controller; they depend on the service and persistence implementation.

### Update a questionnaire's status

```http
PUT /exercises/1
Content-Type: application/x-www-form-urlencoded

exercise[status]=answering
```

**Controller:** `QuestionnairesController#update_status`

| Parameter | Source | Description |
| --- | --- | --- |
| `questionnaire_id` | Path | Questionnaire to update |
| `exercise[status]` | Form | Status passed to `QuestionnairesService#update_questionnaire` |

The application uses these questionnaire statuses:

| Status | Meaning |
| --- | --- |
| `editing` | Questionnaire being prepared |
| `answering` | Questionnaire open for answer submission and editing |
| `closed` | Questionnaire closed for answers |

When the requested status is `answering`, the controller first fetches the questionnaire's questions.

| Condition | Result |
| --- | --- |
| Requested status is `answering` and the questionnaire has no questions | Redirect to `/exercises/:questionnaire_id/fields` without updating the status |
| Otherwise | Call the update service, then redirect to `/exercises` |

The supplied controller does not itself enforce an allowed-status list or a complete status transition policy.

## Questions

Questions belong to a questionnaire and are managed through its `/fields` routes.

The router confirms the following actions. The `QuestionsController` implementation was not supplied, so its exact form field names, view names, validation rules, responses, and redirects are not specified here.

### Display a questionnaire's questions

```http
GET /exercises/1/fields
```

**Controller:** `QuestionsController#fields`

The questionnaire is identified by the first ID in the path.

### Create a question

```http
POST /exercises/1/fields
```

**Controller:** `QuestionsController#create_field`

The route identifies the parent questionnaire. The request's remaining fields are defined by the question form and controller.

### Display the editing form

```http
GET /exercises/1/fields/3/edit
```

**Controller:** `QuestionsController#get_field_by_id`

This example targets question `3` in questionnaire `1`.

### Update a question

```http
PUT /exercises/1/fields/3
```

**Controller:** `QuestionsController#edit_field`

### Delete a question

```http
DELETE /exercises/1/fields/3
```

**Controller:** `QuestionsController#delete_field`

## Answer submissions

A submission groups a set of answers under a `submission_id`. Its editing URL contains both the questionnaire ID and the submission ID.

All four submission form and write actions (`new`, `create`, `edit`, and `update`) require an existing questionnaire whose status is exactly `answering`. Otherwise, they render the `404` view with HTTP status `404`.

### List questionnaires open for answers

```http
GET /exercises/answering
```

**Controller:** `AnswersController#index`

The controller fetches all questionnaires and keeps only those whose `status` is `answering`.

**View:** `exercises/answering`

**View data:** `questionnaires`

### Display a new answer form

```http
GET /exercises/1/fulfillments/new
```

**Controller:** `AnswersController#new`

The questionnaire must be open for answers and contain at least one question. A questionnaire without questions produces the `404` view with HTTP status `404`.

**View:** `exercises/fulfillments/form`

| View data | Value |
| --- | --- |
| `questionnaire` | Selected questionnaire |
| `questions` | Questions belonging to the questionnaire |
| `answers` | Empty hash |
| `form_action` | `/exercises/:questionnaire_id/fulfillments` |
| `editing` | `false` |

### Create a submission

```http
POST /exercises/1/fulfillments
Content-Type: application/x-www-form-urlencoded

answers[3]=A+reusable+block+of+code&answers[4]=42
```

**Controller:** `AnswersController#create`

| Form field | Description |
| --- | --- |
| `answers[question_id]` | Answer associated with a question ID; repeat for each question |

For example, `answers[3]` supplies the answer to question `3`. The controller reads the nested `answers` hash, or uses an empty hash when that parameter is absent.

The controller checks that the questionnaire is open for answers and contains questions, then calls:

```ruby
@answers_service.create_submission(questions, answers)
```

The service returns a `submission_id`.

**Redirect:** `/exercises/:questionnaire_id/fulfillments/:submission_id/edit`

For example, submission `7` for questionnaire `1` redirects to `/exercises/1/fulfillments/7/edit`.

If an `ArgumentError` is raised during the action, the response is `400 Bad Request` with the plain-text body `Invalid answers`.

### Display a saved submission

```http
GET /exercises/1/fulfillments/7/edit
```

**Controller:** `AnswersController#edit`

The controller retrieves saved answers using both the questionnaire ID and the submission ID. If no saved answers are returned, it renders the `404` view with HTTP status `404`.

Saved answers are converted into a hash keyed by question ID strings:

```ruby
{
  "3" => "A reusable block of code",
  "4" => "42"
}
```

**View:** `exercises/fulfillments/form`

| View data | Value |
| --- | --- |
| `questionnaire` | Selected questionnaire |
| `questions` | Questions belonging to the questionnaire |
| `answers` | Saved answer values keyed by question ID |
| `form_action` | `/exercises/:questionnaire_id/fulfillments/:submission_id` |
| `editing` | `true` |

The application uses the same view for creating and editing a submission.

### Update a saved submission

```http
PUT /exercises/1/fulfillments/7
Content-Type: application/x-www-form-urlencoded

answers[3]=An+updated+answer&answers[4]=43
```

**Controller:** `AnswersController#update`

The controller checks that the questionnaire is open for answers and that saved answers exist for this questionnaire and submission. It then passes the submitted answer hash and the questionnaire's current questions to:

```ruby
@answers_service.update_submission(submission_id, questionnaire_questions, answers)
```

**Redirect:** `/exercises/:questionnaire_id/fulfillments/:submission_id/edit`

If an `ArgumentError` is raised during the action, the response is `400 Bad Request` with the plain-text body `Invalid answers`.

## Errors and special cases

| Situation | Response |
| --- | --- |
| No route matches the path and HTTP method | `404` HTML view |
| A submission action targets a missing questionnaire or one whose status is not `answering` | `404` HTML view |
| Creating or opening a new submission for a questionnaire without questions | `404` HTML view |
| Editing or updating a submission returns no saved answers | `404` HTML view |
| `ArgumentError` is raised in submission creation or update | `400 Bad Request`, plain text: `Invalid answers` |
| Switching a questionnaire without questions to `answering` | Redirect to its question management page without changing the status |

Other validation and error behavior depends on the services, repositories, `QuestionsController`, and `BaseController` implementations.

## Typical workflows

### Prepare a questionnaire

1. Open `/exercises/new`.
2. Submit its title through `POST /exercises`.
3. Follow the redirect to `/exercises/:questionnaire_id/fields`.
4. Add questions through `POST /exercises/:questionnaire_id/fields`.
5. Update the questionnaire's status to `answering` through `PUT /exercises/:questionnaire_id`.

### Answer a questionnaire

1. Open `/exercises/answering`.
2. Open `/exercises/:questionnaire_id/fulfillments/new` for a questionnaire containing questions.
3. Submit answers through `POST /exercises/:questionnaire_id/fulfillments`.
4. Follow the redirect to the saved submission's editing page.
5. Modify answers through `PUT /exercises/:questionnaire_id/fulfillments/:submission_id` while the questionnaire remains in `answering` status.
