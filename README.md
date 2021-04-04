# Canvas

Small API server to represent an ASCII art drawing canvas.

### Requirements

- Mac / Linux
- Elixir
- Postgres

### Install

```bash
$ git clone git@github.com:vtm9/canvas.git
$ cd canvas
$ make pg
$ make setup
```

## Usage

```bash
$ make server
```

## API

### Create a new image

```bash
 curl -X POST  http://localhost:4000/api/v1/images -H "Content-Type: application/json" \
-d '{"image": {"width": 10, "height": 10}}'

# response
status: 201
body: {"id": 1 "width": 10, "height": 10, "canvas": ""}
```

### Create a rectangle for image

```bash
 curl -X POST  http://localhost:4000/api/v1/images/:image_id/drawing \
-H "Content-Type: application/json" \
-d '{"drawing": {"type": "rectangle", "props": {"corner": [1,1], "width": 10, "height": 10, "fill": "A", "outline": "B"}}}'

# response
status: 201
body:
{
  "id": 1,
  "image_id": 2,
  "type": "rectangle",
    "props": %{
      "corner": [1, 1],
      "width": 10,
      "height": 10,
      "fill": "A",
      "outline": "A"
    }
}

```

### Create a flood fill for image

```bash
 curl -X POST  http://localhost:4000/api/v1/images/:image_id/drawing \
-H "Content-Type: application/json" \
-d '{"drawing": {"type": "flood", "props" {"point": [1,1], "char": "A"}}}'

# response
status: 201
body: 
{
  "id": 2,
  "image_id": 2,
  "type": "flood",
    "props": %{
      "point": [1, 1],
      "char": "A"
    }
}
```

### Show image

```bash
 curl -X GET http://localhost:4000/api/v1/images/:id \
-H "Content-Type: application/json"

# response
status: 200
body: {
"id": 37,
"width": 21,
"height": 8,
"canvas":
"
              .......
              .......
              .......
OOOOOOOO      .......
O      O      .......
O    XXXXX    .......
OOOOOXXXXX
     XXXXX
"
}
```
