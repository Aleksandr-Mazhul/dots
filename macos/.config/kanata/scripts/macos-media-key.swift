import AppKit
import Darwin
import Foundation

/// Kanata only touches hold files (must return instantly).
/// This process, running in the Aqua session, owns NX_KEYTYPE pulses and HUD.
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

let holdKeys = ["brightness-up", "brightness-down", "volume-up", "volume-down"]
let initialRepeatDelay: TimeInterval = 0.35
let repeatInterval: TimeInterval = 0.08
let staleHold: TimeInterval = 15
let holdDir = "/tmp"

func holdPath(_ name: String) -> String { "\(holdDir)/macos-media-key-\(name).hold" }
func daemonPidPath() -> String { "\(holdDir)/macos-media-key.daemon.pid" }

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
}

func opposites(_ name: String) -> [String] {
    switch name {
    case "brightness-up": return ["brightness-down"]
    case "brightness-down": return ["brightness-up"]
    case "volume-up": return ["volume-down"]
    case "volume-down": return ["volume-up"]
    default: return []
    }
}

func startHold(name: String) {
    for other in opposites(name) {
        unlink(holdPath(other))
    }
    unlink(holdPath(name))
    FileManager.default.createFile(
        atPath: holdPath(name),
        contents: Data("1".utf8),
        attributes: [.posixPermissions: 0o666]
    )
}

func stopHold(name: String) {
    unlink(holdPath(name))
}

func isHolding(_ name: String) -> Bool {
    var st = stat()
    guard stat(holdPath(name), &st) == 0 else { return false }
    let age = Date().timeIntervalSince1970 - TimeInterval(st.st_mtimespec.tv_sec)
    if age > staleHold {
        unlink(holdPath(name))
        return false
    }
    return true
}

func currentHold() -> String? {
    var newest: (name: String, mtime: TimeInterval)?
    for name in holdKeys {
        var st = stat()
        guard stat(holdPath(name), &st) == 0 else { continue }
        let age = Date().timeIntervalSince1970 - TimeInterval(st.st_mtimespec.tv_sec)
        if age > staleHold {
            unlink(holdPath(name))
            continue
        }
        let mtime = TimeInterval(st.st_mtimespec.tv_sec)
            + TimeInterval(st.st_mtimespec.tv_nsec) / 1_000_000_000
        if newest == nil || mtime > newest!.mtime {
            newest = (name, mtime)
        }
    }
    return newest?.name
}

func runDaemon() {
    signal(SIGTERM) { _ in
        unlink(daemonPidPath())
        for name in holdKeys { unlink(holdPath(name)) }
        exit(0)
    }
    signal(SIGINT) { _ in
        unlink(daemonPidPath())
        exit(0)
    }

    try? "\(ProcessInfo.processInfo.processIdentifier)".write(
        toFile: daemonPidPath(),
        atomically: true,
        encoding: .utf8
    )
    chmod(daemonPidPath(), 0o644)

    var active: String?
    var holdBegan = Date.distantPast
    var lastPulse = Date.distantPast

    Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
        let held = currentHold()
        guard let name = held, let key = names[name] else {
            active = nil
            return
        }
        let now = Date()
        if active != name {
            active = name
            holdBegan = now
            pulse(key)
            lastPulse = now
            return
        }
        if now.timeIntervalSince(holdBegan) >= initialRepeatDelay,
           now.timeIntervalSince(lastPulse) >= repeatInterval
        {
            pulse(key)
            lastPulse = now
        }
    }

    RunLoop.current.run()
}

let args = Array(CommandLine.arguments.dropFirst())
guard let action = args.first else {
    fputs(
        "usage: macos-media-key <daemon|hold-start|hold-stop|volume-up|...> [name]\n",
        stderr
    )
    exit(2)
}

if action == "daemon" {
    runDaemon()
    exit(0)
}

if action == "hold-start" || action == "hold-stop" {
    guard let name = args.dropFirst().first, names[name] != nil else {
        fputs("hold commands need a key name\n", stderr)
        exit(2)
    }
    if action == "hold-start" {
        startHold(name: name)
    } else {
        stopHold(name: name)
    }
    exit(0)
}

guard let key = names[action] else {
    fputs(
        "usage: macos-media-key <daemon|hold-start|hold-stop|volume-up|volume-down|mute|brightness-up|brightness-down|play-pause|next|prev> [name]\n",
        stderr
    )
    exit(2)
}

pulse(key)
RunLoop.current.run(until: Date().addingTimeInterval(0.03))
