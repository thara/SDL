//
//  Audio.swift
//  SDL
//
//  Created by Tomochika Hara on 3/4/20.
//
import CSDL2

public typealias SDLAudioCallback = (UnsafeMutablePointer<UInt8>, Int32) -> Void

public typealias SDLAudioSpec = SDL_AudioSpec

extension SDLAudioSpec {
    public mutating func callback(_ callback: @escaping SDLAudioCallback) {
        let holder = SDLAudioCallbackHolder(callback: callback)
        self.userdata = Unmanaged<SDLAudioCallbackHolder>.passRetained(holder).toOpaque()

        self.callback = { userdata, stream, len in
            let p = UnsafeRawPointer(userdata)!
            let holder: SDLAudioCallbackHolder = Unmanaged.fromOpaque(p).takeUnretainedValue()
            holder.callback(stream!, len)
        }
    }
}

class SDLAudioCallbackHolder {
    var callback: SDLAudioCallback

    init(callback: @escaping SDLAudioCallback) {
        self.callback = callback
    }
}


public func openAudio(desired: inout SDLAudioSpec, obtained: inout SDLAudioSpec?) {
    if var obtained = obtained {
        SDL_OpenAudio(&desired, &obtained)
    } else {
        SDL_OpenAudio(&desired, nil)
    }
}

public func closeAudio() {
    SDL_CloseAudio()
}

public func pauseAudio(_ pauseOn: Bool) {
    SDL_PauseAudio(pauseOn ? 1 : 0)
}
