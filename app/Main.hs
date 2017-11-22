{-# LANGUAGE RecordWildCards #-}

module Main where

import Data.Text (pack)
import Servant
import Network.Wai
import Network.Wai.Handler.Warp
import System.Environment
import Database.MongoDB
import Types
import Api
import Env
import qualified Configuration.Dotenv as Dotenv

karmas :: [Karma]
karmas =
  [ Karma "teamone" "userone" 100
  , Karma "teamtwo" "karmatwo" 1
  ]

karma = Karma "team" "user" 100

--server :: Pipe -> Server Routes -- Cleaner typing style for later refactoring
server :: Pipe -> IncomingRequest -> Handler WebhookResponse
server pipe req =
  mongoWrite command
  return $ buildResult command
  where
    command = parseCommand req

parseCommand :: IncomingRequest -> SlackCommand
parseCommand arg = Help

buildResult :: SlackCommand -> IO WebhookResponse
buildResult cmd = WebhookResponse "test" "somechannel" "someuser"

mongoWrite :: SlackCommand -> IO ()
mongoWrite Help = return ()
mongoWrite Init = return ()
mongoWrite (Positive amount username teamname) = return ()
mongoWrite (Negative amount username teamname) = return ()
mongoWrite (UserTotal username teamname) = return ()
mongoWrite (TeamTotal teamname) = return ()

app :: Pipe -> Application
app pipe = serve karmaApi $ server pipe

main :: IO ()
main = do
  EnvVars{..} <- getEnvVars ".env"
  pipe <- connect (Host dbEndpoint (PortNumber 26762)) -- Issue with Num vs Int etc.
  authenticated <- access pipe master dbName $ auth dbUsr dbPass
  run 8081 $ app pipe
