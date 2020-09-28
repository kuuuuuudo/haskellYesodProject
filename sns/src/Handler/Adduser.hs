{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

module Handler.Adduser where

import Import

adduserForm :: Maybe User -> Html -> MForm Handler (FormResult User, Widget)
adduserForm user extra = do
    (identResult,identView) <- mreq textField "ユーザー名" (userIdent <$> user)
    (passwordResult,passwordView) <- mopt textField "パスワード" (userPassword <$> user)
    let 
        result = User
         <$> identResult
         <*> passwordResult
        widget = $(widgetFile "adduser-form")
    return (result, widget)

getAdduserR :: Handler Html
getAdduserR = do
    let
        header = "ユーザー登録" :: Text
    (widget, enctype) <- generateFormPost $ adduserForm Nothing
    defaultLayout $(widgetFile "adduser")

postAdduserR :: Handler Html
postAdduserR = do
    ((result, widget),enctype) <- runFormPost $ adduserForm Nothing
    let
        header = "ユーザー登録" :: Text
    case result of
        FormSuccess adduser -> do
            adduserId <- runDB $ insert adduser
            redirect LoginuserR
        FormFailure _ -> do
            -- 不正な入力値のデータが送信された場合(必須項目が未入力等)
            setMessage "不正なデータが送信されました。"
            defaultLayout $(widgetFile "adduser")
        FormMissing -> defaultLayout [whamlet|データが送信されませんでした。 |]
        _ -> Import.undefined
