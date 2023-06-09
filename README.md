# Http Client Plugin

**Http Client Plugin** code generator powered by `Tachyon`.

This plugin allows you to generate http services using `Dio` as your http client.

## How it works

**Http Client Plugin** uses `Tachyon` as it's build engine to provide fast code generation. Also this plugin uses the [analyzer](https://pub.dev/packages/analyzer) system and [analyzer plugin](https://pub.dev/packages/analyzer_plugin)
to get access on the source code, parse it and provide `code actions` based on that.

These `code actions` are similar to the ones provide by the language - e.g. `wrap with try/catch` - so you don't need to rely on snippets or manually typing any boilerplate code.

## Installation

1. In your project's `pubspec.yaml` add

   ```yaml
   dependencies:
     http_client_plugin: any

   dev_dependencies:
     tachyon: any
   ```

1. Create `tachyon_config.yaml` on the project's root folder

   ```yaml
   file_generation_paths: # which files/paths to include for build
     - "file/path/to/watch"
     - "another/one"

   generated_file_line_length: 80 # default line length

   plugins:
     - http_client_plugin # register http_client_plugin
   ```

1. Update your `analysis_options.yaml` (to enable `code action`)

   **Minimal analysis_options.yaml**

   ```yaml
   include: package:lints/recommended.yaml

   # You need to register the plugin under analyzer > plugins
   analyzer:
     plugins:
       - http_client_plugin
   ```

1. Restart the analysis server

   **VSCode**

   1. Open the Command Palette
      1. **Windows/Linux:** Ctrl + Shift + P
      1. **MacOS:** ⌘ + Shift + P
   1. Type and select "Dart: Restart Analysis Server"

   **IntelliJ**

   1. Open Find Action
      1. **Windows/Linux:** Ctrl + Shift + A
      1. **MacOS:** ⌘ + Shift + A
   1. Type and select "Restart Dart Analysis Server"

## Generate the code you want!

### DataClass Annotation

1. Create a simple class, annotate it with `@HttpService()`

   ```dart
   @HttpService()
   class AppHttpService { ... }
   ```

1. Add abstract methods annotated with `@HttpMethod.*` and add a return type of `FutureHttpResult<*>`

   ```dart
   @HttpService()
   class AppHttpService {

      @HttpMethod.get('/user')
      FutureHttpResult<User> getUser(@QueryParam() int userId);

   }
   ```

1. Run code actions on your IDE

   VSCode

   1. **Windows/Linux:** Ctrl + .
   1. **MacOS:** ⌘ + .

   Intellij

   1. **Windows/Linux:** Alt + Enter
   1. **MacOS:** ⌘ + Enter

1. Select `Generate http services`

<img src="https://raw.githubusercontent.com/spideythewebhead/http_client_plugin/main/assets/screenshots/generate_http_services.png">

This will generate all the boilerplate code on the source file.

Now to generate the part file code you need to run tachyon.

Executing tachyon:

`dart run tachyon build`

See more options about tachyon by executing: `dart run tachyon --help`

## Annotations

1. ### HttpService

   Annotates a class as an http service class.

   Receives an optional `path` parameter.

   Example:

   ```dart
   @HttpService('/api/v0') // all paths will be prefixed with /api/v0
   class AppHttpService {

      @HttpMethod.get('/ping') // this will become base url + /api/v0 + /ping
      FutureHttpResult<void> ping();

   }
   ```

1. ### HttpMethod

   Annotates a method which http verb to use. Available `HttpMethod` verbs:

   - HttpMethod.get()
   - HttpMethod.post()
   - HttpMethod.put()
   - HttpMethod.delete()
     <br />
     <br />

   Receives an required `path` parameter. The path can be an empty string.

   Example:

   ```dart
   @HttpService()
   class AppHttpService {

      @HttpMethod.get('/users')
      FutureHttpResult<List<User>> getUsers();

   }
   ```

1. ### QueryParam

   Annotates a method's parameter as a query parameter.

   Receives an optional alternative name for the query parameter name.

   ```dart
   @HttpService()
   class AppHttpService {

      @HttpMethod.get('/user')
      FutureHttpResult<User> getUser(
         // the query parameter will be set as "userId". See next example how to change that
         @QueryParam() int userId
      );

   }
   ```

   Provide a different query parameter name:

   ```dart
   @HttpService()
   class AppHttpService {

      @HttpMethod.get('/user')
      FutureHttpResult<User> getUser(@QueryParam('user_id') int userId);

   }
   ```

1. ### PathParam

   Annotates a method's parameter as a path parameter.

   In companion with [HttpMethod](#httpmethod) when a path segment starts with `:` matches
   a parameter with the same name and that parameter is annotated with `@PathParam`.

   ```dart
   @HttpService()
   class AppHttpService {

      @HttpMethod.get('/user/:id')
      FutureHttpResult<User> getUser(@PathParam() int id);

   }
   ```

1. ### HttpPayload

   Annotates a method's parameter as the request's payload.

   This can be any primitive type (or a list or map containing primitive data).
   Also there is built in support for `Uri` (which uses `toString`) and `DateTime` (which uses `toIso8601String`).

   Also a class object can be used that contains a `toJson` method that returns any of the above.

   ```dart
   @HttpService()
   class AppHttpService {

      @HttpMethod.post('/user/:id')
      FutureHttpResult<User> updateUser(@HttpPayload() Map<String, dynamic> data);

   }
   ```

1. ### HttpHeader

   Annotates a method with an additional http header.

   ```dart
   @HttpService()
   class AppHttpService {

      @HttpMethod.post('/user/:id')
      @HttpHeader('Content-Type', 'application/json')
      @HttpHeader('Accept', 'application/json')
      FutureHttpResult<User> updateUser(@HttpPayload() Map<String, dynamic> data);

   }
   ```

1. ### HttpMultipart

   Annotates a method as a multipart request.

   Optionally accepts a parameter `listFormat` which indicates how a list should be formatted - default value `MultipartListFormat.multi`. See options [here](https://github.com/spideythewebhead/http_client_plugin/tree/main/lib/src/multipart_list_format.dart).

   ```dart
   @HttpService()
   class AppHttpService {

      @HttpMethod.post('/user')
      @HttpMultipart()
      FutureHttpResult<User> updateUser({
         @HttpFormField() required String username,
         @HttpFormField() required String password,
      });

   }
   ```

1. ### HttpFormField

   Annotates a method's parameter as form field for multipart request.

   ```dart
   @HttpService()
   class AppHttpService {

      @HttpMethod.post('/user')
      @HttpMultipart()
      FutureHttpResult<User> updateUser({
         @HttpFormField() required String username,
         @HttpFormField(name: 'pass') required String password,
      });

   }
   ```

   Multipart requests can also accept a file using the `HttpFormField.file` annotation. The parameter type for this annotation should be a String with a value that points to a file path.

   ```dart
   @HttpService()
   class AppHttpService {

      @HttpMethod.post('/user')
      @HttpMultipart()
      FutureHttpResult<User> updateUser({
         @HttpFormField() required String username,
         @HttpFormField(name: 'pass') required String password,
         @HttpFormField.file() required String pathToFile,
      });

   }
   ```

## Http services

Http services can be nested to provide a more convenient and easy to read code.

```dart

@HttpService()
class AppHttpService {
   UsersHttpService get users;
}

@HttpService()
class UsersHttpService {
   @HttpMethod.get('/user/:id')
   FutureHttpResult<User> getById(@PathParam() int id);
}

...

final AppHttpService httpService = AppHttpService();
final HttpResult<User> result = await httpService.users.getById(11);
```

Also http services can override the default `Dio` client by adding an abstract method:

```dart
@HttpService()
class UsersHttpService {
   UsersHttpService overrideHttpClient(Dio client);
}
```

## Http methods

Http methods must be must have a return type of `FutureHttpResult<*>`.

`FutureHttpResult` is a shortcut for `Future<HttpResult<*>>`

`HttpResult` is a sealed class that is implemented by 2 variants:

- `HttpResultData`

  Contains the parsed data from a successful response.

- `HttpResultFailure`

  Contains the exception thrown from this request and optional stack trace.

Also `HttpResult` provides a helper when/maybeWhen methods that accept callbacks based on the result.

### Example

See example [here](https://github.com/spideythewebhead/http_client_plugin/tree/main/example).
