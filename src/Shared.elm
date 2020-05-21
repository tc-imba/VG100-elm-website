module Shared exposing (Flags, RemoteData(..), mapRemoteData)


type alias Flags =
    { api : String
    , prefix: String
    , version: Version
    }

type alias Version =
    { name : String
    , timestamp : String
    , version : String
    , env : String
    , git : String
    , dirty : Bool
    }


type RemoteData a
    = NotAsked
    | Loading
    | Loaded a
    | Failure


mapRemoteData : (a -> b) -> RemoteData a -> RemoteData b
mapRemoteData fn remoteData =
    case remoteData of
        NotAsked ->
            NotAsked

        Loading ->
            Loading

        Loaded data ->
            Loaded (fn data)

        Failure ->
            Failure
