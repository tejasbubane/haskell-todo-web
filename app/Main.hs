{-# language OverloadedStrings #-}
module Main where

import Web.Firefly
import qualified Data.Text as T
import Text.Blaze.Html5 as H hiding (main)
import qualified Text.Blaze.Html5.Attributes as A
import Data.Maybe

main :: IO ()
main = run 3000 app

app :: App ()
app = do
  route "/hello" helloHandler
  route "/todos" todoHandler
  route "/add-todo" addTodoHandler

helloHandler :: Handler T.Text
helloHandler = do
  name <- fromMaybe "Stranger" <$> getQuery "name"
  return $ "Hello" `T.append` " " `T.append` name

todoHandler :: Handler H.Html
todoHandler = do
  return . H.docTypeHtml $ do
    H.head $ do
      title "Haskell TODO"
    body $ do
      h1 "Add TODOs"
      form ! A.method "get" ! A.action "/add-todo" $ do
        input ! A.type_ "text" ! A.id "todo-input" ! A.name "todo"
        input ! A.type_ "submit" ! A.value "Submit"

addTodoHandler :: Handler T.Text
addTodoHandler = do
  todo <- fromMaybe "" <$> getQuery "todo"
  return $ "Added" `T.append` " " `T.append` todo
