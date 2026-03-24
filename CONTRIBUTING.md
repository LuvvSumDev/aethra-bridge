# Contributing to Aethra Bridge

Thanks for your interest in contributing. This guide covers the basics for submitting issues, suggesting features, and opening pull requests.

## Reporting Bugs

Use the [bug report template](https://github.com/LuvvSumDev/aethra-bridge/issues/new?template=bug_report.yml) and include:

- Your framework and inventory (e.g. QBCore + ox_inventory)
- Steps to reproduce the issue
- Expected vs actual behavior
- Server artifacts version and ox_lib version

## Suggesting Features

Use the [feature request template](https://github.com/LuvvSumDev/aethra-bridge/issues/new?template=feature_request.yml). Describe the use case clearly, what problem does it solve and why should it be in the bridge rather than in individual scripts?

## Pull Requests

1. Fork the repository and create your branch from `main`.
2. Keep changes focused. One feature or fix per PR.
3. Follow the existing code style:
   - Use early returns with framework guards (`if Bridge.framework ~= 'x' then return end`)
   - Cache exports and framework objects at module level, not per-call
   - Use `lib.print.*` for logging, never `print()`
4. Test on at least one supported framework before submitting.
5. Fill out the PR template completely.

## Code Style

- Lua 5.4 features are enabled, use them where appropriate
- Use ox_lib utilities (`cache.ped`, `lib.callback`, `string.random`, etc.)
- Keep functions minimal, no over-engineering or premature abstractions
- Match the patterns in existing bridge modules

## Adding Support for a New Resource

To add a new resource to an existing category (e.g. a new inventory):

1. Create a new file in the appropriate subdirectory (e.g. `server/inventory/your-inventory.lua`)
2. Add a framework guard at the top: `if Bridge.inventory ~= 'your-inventory' then return end`
3. Implement all required `_` prefixed functions (e.g. `_getItemCount`, `_addItem`, etc.)
4. Add the resource to the detection map in `shared/init.lua`
5. Add the option to `data/config.lua` comments
6. Update the README compatibility table

## Questions?

Open a [discussion](https://github.com/LuvvSumDev/aethra-bridge/discussions) or reach out on our [Discord](https://discord.gg/YRKWexFavD).
