//
//  Semaphore.swift
//  SDL
//
//  Created by Tomochika Hara on 3/4/20.
//
import CSDL2

public final class SDLSemaphore {
    // MARK: - Properties
    internal let internalPointer: OpaquePointer

    // MARK: - Initialization
    deinit {
        SDL_DestroySemaphore(internalPointer)
    }

    public init(initialValue: UInt32) {
        internalPointer = SDL_CreateSemaphore(initialValue)
    }

    // MARK: - Accessors
    public var value: UInt32 {
        SDL_SemValue(internalPointer)
    }

    // MARK: - Methods

    public func post() throws {
        try SDL_SemPost(internalPointer).sdlThrow(type: type(of: self))
    }

    public func wait() throws {
        try SDL_SemWait(internalPointer).sdlThrow(type: type(of: self))
    }

    public func wait(until milliseconds: UInt32) throws {
        try SDL_SemWaitTimeout(internalPointer, milliseconds).sdlThrow(type: type(of: self))
    }

    public func tryWait() throws {
        try SDL_SemTryWait(internalPointer).sdlThrow(type: type(of: self))
    }
}
