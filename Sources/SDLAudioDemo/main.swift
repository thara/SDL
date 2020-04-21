import CSDL2
import SDL

class SquareWave {

    var phase_inc: Float
    var phase: Float = 0.0
    var volume: Float = 0.25

    var audioSpec = SDLAudioSpec()

    init() {
        audioSpec.freq = 44_100
        audioSpec.format = UInt16(AUDIO_F32LSB)
        audioSpec.channels = 1

        phase_inc = 440.0 / Float(audioSpec.freq)

        audioSpec.setCallback(userdata: self) { (wave, samples, count) in
            let bufferCount = Int(count) / MemoryLayout<Float>.size
            samples.withMemoryRebound(to: Float.self, capacity: bufferCount) { p in
                let p = UnsafeMutableBufferPointer(start: p, count: bufferCount)

                for i in stride(from: p.startIndex, to: p.endIndex, by: 1) {
                    let x = wave.phase <= 0.5 ? wave.volume : -wave.volume
                    p[i] = x
                    wave.phase = (wave.phase + wave.phase_inc).truncatingRemainder(dividingBy: 1.0)
                }
            }
        }
        print(audioSpec)
    }
}

func main() throws {
    try SDL.initialize(subSystems: [.audio])

    var wave = SquareWave()

    var obtained: SDLAudioSpec?
    try openAudio(desired: &wave.audioSpec, obtained: &obtained)
    pauseAudio(false)

    defer {
        pauseAudio(true)
        closeAudio()
    }

    sleep(2)
}

do { try main() }
catch let error as SDLError {
    print("Error: \(error.debugDescription)")
    exit(EXIT_FAILURE)
}
catch {
    print("Error: \(error)")
    exit(EXIT_FAILURE)
}
