
# Flutter Project Rules

## 1. General Instructions
- Before implementing any feature, inspect the existing project structure
  and understand the current architecture.
- Reuse existing classes, services, utilities, themes, and components.
- Do not create duplicate implementations of existing functionality.
- Follow the project's existing naming conventions and coding style.
- Do not modify unrelated files.
- Do not assume a package, API, method, or class exists without checking.
- If a requirement is ambiguous, ask for clarification before making
  significant architectural decisions.

## 2. Architecture and Dependency Injection
- Keep the existing project architecture and folder structure.
- Use GetIt through injection_container.dart for dependency injection.
- Register each dependency only once.
- Use BlocProvider or MultiBlocProvider to provide Cubits to widgets.
- Use BlocBuilder for UI rendering and BlocListener for side effects.
- Choose Cubit lifecycle and dependency registration based on ownership
  and intended scope.
- Do not instantiate shared dependencies directly inside UI widgets.
- Avoid circular imports and circular dependencies.

## 3. Localization: Arabic and English
- The application must support both Arabic and English.
- English is the default language on first launch.
- Before adding any user-facing text, inspect the existing localization
  implementation and local_strings.dart.
- Add every new UI string to the existing localization system.
- Provide both English and Arabic translations for every new string.
- Never hardcode user-facing text directly inside widgets.
- Reuse existing localization keys when they represent the same meaning.
- Do not change the user's saved language preference unexpectedly.
- Verify that changing the language updates the UI correctly.

## 4. RTL and LTR Layout
- Support both right-to-left (RTL) Arabic and left-to-right (LTR) English.
- Prefer Directionality-aware widgets and properties.
- Use AlignmentDirectional, EdgeInsetsDirectional, and
  BorderRadiusDirectional when appropriate.
- Prefer TextAlign.start and TextAlign.end over left and right
  when alignment should follow the current text direction.
- Avoid hardcoded left/right padding and alignment unless the design
  explicitly requires a physical direction.
- Test important layouts in both Arabic and English.

## 5. API and Dio
- Use the existing ApiConsumer, DioConsumer, and AppInterceptor.
- Do not create a second Dio client or duplicate interceptors without
  a clear architectural reason.
- English is the default API language on first launch.
- Send the appropriate API language header on requests according to
  the application's active language, using the backend's expected
  header name and language-code format.
- Do not hardcode English on every request if the user has selected Arabic.
- Inspect the existing API contract before changing request headers.
- Preserve existing authentication, error handling, and token behavior.
- Handle loading, success, empty, and error states appropriately.
- Never log passwords, access tokens, or other sensitive information.

## 6. State Management
- Use the existing flutter_bloc package and project conventions.
- Keep business logic out of widgets whenever practical.
- Use Cubit or Bloc according to the existing feature architecture.
- Avoid unnecessary rebuilds and dispose of resources correctly.
- Do not register the same dependency multiple times.
- Do not create global Cubits for screen-specific state without a reason.

## 7. UI and Design
- Reuse existing light and dark themes, colors, typography, and components.
- Use the existing ScreenUtil conventions consistently.
- Build responsive layouts that work on different screen sizes.
- Support keyboard visibility, scrolling, loading states, and empty states
  where relevant.
- Do not introduce a new design system or dependency without a reason.
- Follow the supplied design as closely as possible.

## 8. Code Quality and Safety
- Prefer readable, maintainable, and modular code.
- Avoid unnecessary abstractions and overengineering.
- Use null safety and appropriate error handling.
- Do not silently swallow exceptions.
- Do not change public APIs or existing behavior without justification.
- Do not remove existing functionality to make a new feature work.

## 9. Before Finishing Any Task
- Review all modified files and their dependencies.
- Run dart format on changed Dart files.
- Run flutter analyze and address relevant issues.
- Run appropriate tests when available.
- Verify that the implementation is consistent with these rules.
- Report what changed, which checks passed, and any remaining issues.
- Never claim a command or test passed unless it was actually executed.
