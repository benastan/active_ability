# ActiveAbility

## Usage

You don't really want granular authorization. You want objects that scope queries across one, two or more models.

Moreover, you want a framework that knows which ability object to provide to your controller, based on parameters.

Here's an ability that combines a Book model and an Author model:

```
class BookAuthor
    extend ActiveAbility::Ability
    authorizes :author_id, through: :current_user, resource: :book_id
end
```

Here's your controller:

```
class BooksController < ActiveController::Base
    extend ActiveAbility::Controller

    def show
        ability.book
        #~$ ability.author.books.find(book_id)
        # Blows up if book isn't member of `author.books` relation.
    end
end
```
