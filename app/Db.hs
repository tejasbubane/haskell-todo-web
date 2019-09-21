{-# language OverloadedStrings #-}
module Db where

import Data.Text
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.ToField
import GHC.Int

data Todo = Todo { name :: Text, completed :: Bool } deriving Show

instance FromRow Todo where
  fromRow = Todo <$> field <*> field

instance ToRow Todo where
  toRow todo = [toField (name todo), toField (completed todo)]

allTodos :: Connection -> IO [Todo]
allTodos c = query_ c "SELECT name, completed FROM todos"

saveTodo :: Connection -> Todo -> IO Int64
saveTodo c t = execute c "INSERT INTO todos (name, completed) VALUES (?, ?)" $ t

getConnection :: IO Connection
getConnection =
  connect defaultConnectInfo { connectUser = "tejas.bubane",
                               connectDatabase = "haskell-todo-app" }
