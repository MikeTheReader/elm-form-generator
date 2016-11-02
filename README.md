
# Elm Form Generator

## About

The Elm Form Generator is a personal learning project geared around implementing a form generator using the Elm programming language http://elm-lang.org/.

It is a re-implementation of a React/Redux project I did at https://github.com/MikeTheReader/redux-field-creator. In fact, to use it fully with the REST API, it uses the Django project in that project to serve up the data. (Though it also runs in "offline" mode with dummy data when the REST API is not present locally.)

## Running

1. Install Gulp

    `npm install -g gulp`

2. Install node dependencies

    `npm install`

3. Install Elm dependencies

    `elm package install` (And accept the plan)

4. Run default gulp task

    `gulp`

This will start a server on your local machine at the default port of 4000. Point your browser at http://localhost:4000, and you can see the application.

If there is no REST API from the https://github.com/MikeTheReader/redux-field-creator running on port 8001, you will see dummy data, but you'll be able to see the application
function.

## Notes

I will be adding more comments to the code, and probably restructuring
it here soon. This is a learning project, so I'm sure there are some
inefficiencies in code use. If you see some, let me know.

There are some things that I haven't fully hooked up, yet, too:

* Being able to specify a list of options for a field
* Having the minimum/maximum only show up when appropriate
* Having the minimum/maximum be the correct field type
* Having the default value be the correct field type
* Using a fancy UI component for the Boolean Field presentation (thinking toggle rather than a checkbox)

## Thanks

Thanks to the folks at http://elmlang.slack.com for helping me when I
hit snags. Great group of people over there, very willing to help a
beginner.

Thanks to https://github.com/andrewsuzuki/elm-todo-rest-api for a good
sample project to follow along with.
