module Charme (charme) where

import Import

charme :: RIO App ()
charme = do
  logInfo "We're inside the application!"
