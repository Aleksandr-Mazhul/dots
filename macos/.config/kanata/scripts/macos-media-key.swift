import AppKit
import Foundation

/// Native-style media key: one NX_KEYTYPE pulse, then optional hold-repeat.
/// Repeat is gated by a /tmp hold file so key-up always stops within ~10ms.
enum NXKey: Int32 {
    case soundUp = 0
    case soundDown = 1
    case brightnessUp = 2
    case brightnessDown = 3
    case mute = 7
    case play = 16
    case next = 17
    case previous = 18
}

let names: [String: NXKey] = [
    "volume-up": .soundUp, "sound-up": .soundUp, "volu": .soundUp,
    "volume-down": .soundDown, "sound-down": .soundDown, "vold": .soundDown,
    "brightness-up": .brightnessUp, "brup": .brightnessUp,
    "brightness-down": .brightnessDown, "brdn": .brightnessDown,
    "mute": .mute,
    "play-pause": .play, "play": .play, "pp": .play,
    "next": .next,
    "previous": .previous, "prev": .previous,
]

func holdPath(_ name: String) -> String { "/tmp/macos-media-key-\(name).hold" }
func pidPath(_ name: String) -> String { "/tmp/macos-media-key-\(name).pid" }

func pulse(_ key: NXKey) {
    for down in [true, false] {
        let flags = NSEvent.ModifierFlags(rawValue: down ? 0xA00 : 0xB00)
        let data1 = Int((Int(key.rawValue) << 16) | (down ? 0x0A00 : 0x0B00))
        guard let event = NSEvent.otherEvent(
            with: .systemDefined,
            location: .zero,
            modifierFlags: flags,
            timestamp: ProcessInfo.processInfo.systemUptime,
            windowNumber: 0,
            context: nil,
            subtype: 8,
            data1: data1,
            data2: -1
        ), let cgEvent = event.cgEvent else { continue }
        cgEvent.post(tap: .cghidEventTap)
    }
    RunLoop.current.run(until: Date().addingTimeInterval(0.015))
}

func isHolding(_ name: String) -> Bool {
    access(holdPath(name), F_OK) == 0
}

/// Poll the hold file every 10ms. Returns false as soon as the key is released.
func waitWhileHolding(_ name: String, seconds: Double) -> Bool {
    let deadline = Date().addingTimeInterval(seconds)
    while Date() < deadline {
        if !isHolding(name) { return false }
        usleep(10_000)
    }
    return isHolding(name)
}

func stopHold(name: String) {
    unlink(holdPath(name))
    if let text = try? String(contentsOfFile: pidPath(name), encoding: .utf8),
       let pid = pid_t(text.trimmingCharacters(in: .whitespacesAndNewlines)),
       pid > 1
    {
        kill(pid, SIGTERM)
        usleep(20_000)
        kill(pid, SIGKILL)
    }
    unlink(pidPath(name))
}

func startHold(name: String, key: NXKey) {
    stopHold(name: name)
    FileManager.default.createFile(atPath: holdPath(name), contents: Data("1".utf8), attributes: [.posixPermissions: 0o666])
    pulse(key)

    let child = Process()
    child.executableURL = URL(fileURLWithPath: CommandLine.arguments[0])
    child.arguments = ["hold-run", name]
    child.standardOutput = FileHandle.nullDevice
    child.standardError = FileHandle.nullDevice
    try? child.run()
    try? "\(child.processIdentifier)".write(toFile: pidPath(name), atomically: true, encoding: .utf8)
}

func runHold(name: String, key: NXKey) {
    signal(SIGTERM) { _ in exit(0) }
    signal(SIGINT) { _ in exit(0) }
    let started = Date()
    // Parent already sent the first step. Wait like a real key, then repeat.
    guard waitWhileHolding(name, seconds: 0.30) else { return }
    while isHolding(name) {
        if Date().timeIntervalSince(started) > 12 { break }
        pulse(key)
        guard waitWhileHolding(name, seconds: 0.08) else { break }
    }
}

let args = Array(CommandLine.arguments.dropFirst())
guard let action = args.first else {
    fputs(
        "usage: macos-media-key <hold-start|hold-stop|volume-up|...> [name]\n",
        stderr
    )
    exit(2)
}

if action == "hold-start" || action == "hold-stop" || action == "hold-run" {
    guard let name = args.dropFirst().first, let key = names[name] else {
        fputs("hold commands need a key name\n", stderr)
        exit(2)
    }
    switch action {
    case "hold-start": startHold(name: name, key: key)
    case "hold-stop": stopHold(name: name)
    case "hold-run": runHold(name: name, key: key)
    default: break
    }
    exit(0)
}

guard let key = names[action] else {
    fputs(
        "usage: macos-media-key <hold-start|hold-stop|volume-up|volume-down|mute|brightness-up|brightness-down|play-pause|next|prev> [name]\n",
        stderr
    )
    exit(2)
}

pulse(key)
