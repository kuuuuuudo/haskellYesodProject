{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

module Handler.Loginuser where

import Import

getLoginuserR :: Handler Html
getLoginuserR = defaultLayout $(widgetFile "loginuser")