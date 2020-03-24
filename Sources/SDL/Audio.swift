//
//  Audio.swift
//  SDL
//
//  Created by Tomochika Hara on 3/4/20.
//
import CSDL2

public typealias SDLAudioCallback<T> = (T, UnsafeMutablePointer<UInt8>, Int32) -> Void

public typealias SDLAudioSpec = SDL_AudioSpec

extension SDLAudioSpec {
    public mutating func setCallback<T>(userdata: T, callback: @escaping SDLAudioCallback<T>) {
        let holder = SDLAudioUserdata(userdata: userdata, callback: callback)
        self.userdata = Unmanaged<SDLAudioUserdata<T>>.passRetained(holder).toOpaque()

        self.callback = { userdata, stream, len in
            let p = UnsafeRawPointer(userdata)!
            let holder: SDLAudioUserdata<AnyObject> = Unmanaged.fromOpaque(p).takeUnretainedValue()
            holder.callback(holder.userdata, stream!, len)
        }
    }
}

class SDLAudioUserdata<T> {
    let userdata: T
    let callback: SDLAudioCallback<T>

    init(userdata: T, callback: @escaping SDLAudioCallback<T>) {
        self.userdata = userdata
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
