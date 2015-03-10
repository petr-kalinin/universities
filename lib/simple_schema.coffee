_.extend SimpleSchema,

  # Данный метод будет из нескольких переданных объектов
  # собирать одну схему и возвращать ее
  build: (objects...) ->
    result = {}
    for obj in objects
      _.extend result, obj
    return new SimpleSchema result
