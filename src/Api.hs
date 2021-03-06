{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Api where

import Servant
import Types

type Routes = "karma" :> ReqBody '[JSON] IncomingRequest :> Post '[JSON] WebhookResponse

karmaApi :: Proxy Routes
karmaApi = Proxy
