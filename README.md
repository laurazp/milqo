# Milqo

Milqo is a simple app for calculating, preparing, and saving homemade plant-based milk recipes (oat, almond, pistachio, cashew, and rice). It answers two very concrete questions: "I want X ml, how much ingredient and water do I need?" and "I have X g of ingredient, how much water do I add?"

This is a first version (MVP) built from a product spec, covering all 10 designed screens: Home, ingredient selection, calculator (both input modes), result, recipe catalog, recipe detail, recipe scaling, unit converter, and favorites.

## Stack

- **Flutter** + **Riverpod** (`Notifier` / `AsyncNotifier` per screen, plain `Provider`s for repositories and use cases) for state management and dependency injection.
- **go_router**, with a `StatefulShellRoute` for the four bottom-tab sections (Home, Calculator, Recipes, Favorites) and root-navigator routes for everything pushed on top.
- **shared_preferences** for local persistence of favorite recipes and saved calculations — no backend, no accounts, everything works offline.
- Recipe/ingredient/ratio/conversion data is bundled as JSON under `assets/data/` and loaded once at startup into an in-memory store; the rest of the app reads it synchronously through the repository layer, same as before it lived there.

## Architecture

```
lib/
  core/            # design system, navigation (go_router), shared Riverpod providers, utils
  data/            # models, JSON-backed local data store, repositories
  domain/usecases/ # calculation, scaling, unit conversion, favorites business logic
  features/        # one folder per screen: controller (Riverpod) + view + widgets
  widgets/         # small shared widgets (badges, empty states, transparency note)
```

## Getting started

```bash
flutter pub get
flutter run
```

No API keys or backend setup required — the app is fully self-contained.
