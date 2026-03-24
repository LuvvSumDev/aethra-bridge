# Aethra Bridge

A universal compatibility bridge for FiveM, built by **Aethra Studios**. Write your scripts once and run them on any supported framework, inventory, target system, and more, without changing a single line of code.

## Features

- **Auto-detection:** Automatically detects which resources are running on your server and configures itself accordingly. No setup required in most cases.
- **Unified API:** One consistent API across all supported frameworks and resources. Access player data, inventory, notifications, targeting, and more through a single interface.
- **Lightweight:** Zero overhead at runtime. Framework-specific modules only load when their framework is detected.
- **Built on ox_lib:** Leverages ox_lib for caching, callbacks, version checking, and logging.

## Supported Resources

| Category          | Resources                                                    |
| ----------------- | ------------------------------------------------------------ |
| **Framework**     | QBCore, QBox, ESX, ox_core                                   |
| **Inventory**     | ox_inventory, qb-inventory, qs-inventory                     |
| **Target**        | ox_target, qb-target                                         |
| **Notifications** | ox_lib, QBCore, ESX                                          |
| **Fuel**          | ox_fuel, LegacyFuel, ps-fuel, cdn-fuel                       |
| **Clothing**      | illenium-appearance, fivem-appearance, qb-clothing, esx_skin |
| **Dispatch**      | ps-dispatch, cd_dispatch, qs-dispatch                        |

## Dependencies

- [ox_lib](https://github.com/communityox/ox_lib)

## Installation

1. Download the [latest release](https://github.com/LuvvSumDev/aethra-bridge/releases/latest).
2. Extract to your server's `resources` directory.
3. Add `ensure aethra-bridge` to your `server.cfg` **before** any resources that depend on it.
4. Restart your server.

## Configuration

Edit `data/config.lua` to override auto-detection for any category:

```lua
return {
    framework = 'auto',  -- 'auto', 'qbox', 'qbcore', 'esx', 'ox_core'
    inventory = 'auto',  -- 'auto', 'ox_inventory', 'qb-inventory', 'qs-inventory'
    notify = 'auto',  -- 'auto', 'ox_lib', 'qbcore', 'esx'
    target = 'auto',  -- 'auto', 'ox_target', 'qb-target'
    fuel = 'auto',  -- 'auto', 'ox_fuel', 'LegacyFuel', 'ps-fuel', 'cdn-fuel'
    clothing = 'auto',  -- 'auto', 'illenium-appearance', 'fivem-appearance', 'qb-clothing', 'esx_skin'
    dispatch = 'auto',  -- 'auto', 'ps-dispatch', 'cd_dispatch', 'qs-dispatch', 'none'
}
```

Set any value to `'none'` to disable that category entirely.

### Debug Logging

aethra-bridge uses ox_lib's print levels. To enable verbose logging for detection output:

```
set ox:printlevel:aethra-bridge 4
```

## Usage

### Accessing the Bridge

From any Aethra resource (with `aethra-bridge` as a dependency):

```lua
-- Via the global (available in shared, client, and server contexts)
local job = Bridge.Client.GetJob()

-- Via export (from external resources)
local Bridge = exports['aethra-bridge']:GetBridge()
```

### Client API

```lua
-- Player
Bridge.Client.GetPlayerData() -- Full player data table
Bridge.Client.GetIdentifier() -- Player identifier string
Bridge.Client.GetJob() -- { name, label, grade, gradeLabel }
Bridge.Client.GetGang() -- { name, label, grade, gradeLabel }
Bridge.Client.HasJob(name, grade?) -- Accepts string or table of names
Bridge.Client.HasGang(name, grade?)
Bridge.Client.HasGroup(name, grade?) -- Checks both job and gang
Bridge.Client.GetMoney(account?) -- 'cash', 'bank', 'crypto'
Bridge.Client.GetName()
Bridge.Client.IsDead()

-- Proximity
Bridge.Client.GetClosestPlayer(range?)
Bridge.Client.GetPlayersInRange(range?)

-- Vehicle
Bridge.Client.GetCurrentVehicle()
Bridge.Client.GetVehicleSeat()
Bridge.Client.IsInVehicle()
```

### Server API

```lua
-- Player
Bridge.Server.GetPlayer(source)
Bridge.Server.GetIdentifier(source)
Bridge.Server.GetName(source)
Bridge.Server.GetJob(source)
Bridge.Server.GetGang(source)
Bridge.Server.HasJob(source, name, grade?)
Bridge.Server.HasGang(source, name, grade?)
Bridge.Server.HasGroup(source, name, grade?)
Bridge.Server.GetPlayers()
Bridge.Server.KickPlayer(source, reason?)

-- Money
Bridge.Server.GetMoney(source, account?)
Bridge.Server.AddMoney(source, account, amount, reason?)
Bridge.Server.RemoveMoney(source, account, amount, reason?)

-- Inventory
Bridge.Inventory.GetItemCount(source, item)
Bridge.Inventory.HasItem(source, item, count?)
Bridge.Inventory.AddItem(source, item, count, metadata?)
Bridge.Inventory.RemoveItem(source, item, count, metadata?)
Bridge.Inventory.GetItems(source)
Bridge.Inventory.RegisterUsableItem(item, cb)
```

### Notifications

```lua
-- Client
Bridge.Notify.Send(msg, type?, duration?, title?)
Bridge.Notify.Help(msg)
Bridge.Notify.Advanced(title, subject, msg, icon?, iconType?)

-- Server
Bridge.Notify.Send(source, msg, type?, duration?, title?)
Bridge.Notify.SendAll(msg, type?, duration?, title?)
```

### Target

```lua
Bridge.Target.AddEntity(entity, options)
Bridge.Target.RemoveEntity(entity, labels)
Bridge.Target.AddBoxZone(name, coords, size, rotation, options)
Bridge.Target.RemoveZone(name)
Bridge.Target.AddModel(models, options)
Bridge.Target.RemoveModel(models, labels)
Bridge.Target.AddPlayer(options)
```

### Fuel

```lua
Bridge.Fuel.GetLevel(vehicle)
Bridge.Fuel.SetLevel(vehicle, level)
```

### Clothing

```lua
Bridge.Clothing.OpenMenu()
Bridge.Clothing.OpenOutfits()
```

### Progress

```lua
Bridge.Progress.Bar(data, cb?)
Bridge.Progress.Circle(data, cb?)
Bridge.Progress.Cancel()
Bridge.Progress.IsActive()
```

### Dispatch

```lua
Bridge.Dispatch.Alert({
    message = 'Store robbery in progress',
    code = '10-90',
    coords = vec3(0, 0, 0), -- optional, defaults to player coords
    jobs = { 'police' }, -- optional, defaults to police
    blip = { -- optional
        sprite = 161,
        color = 1,
        scale = 1.0,
        duration = 10,
    },
})
```

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).

## Links

- [Issues](https://github.com/LuvvSumDev/aethra-bridge/issues) - Bug reports and feature requests
- [Releases](https://github.com/LuvvSumDev/aethra-bridge/releases) - Download stable versions
- [Discord](https://discord.gg/YRKWexFavD) - Community support
