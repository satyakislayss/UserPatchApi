using System;
using System.Configuration;
using Mono.Data.Sqlite;

namespace UserPatchApi.Database
{
    public static class DatabaseConfig
    {
        public static string DbPath =>
            ConfigurationManager.AppSettings["DbPath"] ?? "userpatch.db";

        public static string ConnectionString =>
            $"Data Source={DbPath};Version=3;";

        public static void Initialize()
        {
            using (var conn = new SqliteConnection(ConnectionString))
            {
                conn.Open();
                var cmd = conn.CreateCommand();
                cmd.CommandText = @"
                    CREATE TABLE IF NOT EXISTS Customers (
                        Cliref   TEXT PRIMARY KEY NOT NULL,
                        FullName TEXT NOT NULL,
                        Email    TEXT NOT NULL,
                        Mobile   TEXT NOT NULL
                    );";
                cmd.ExecuteNonQuery();
                Console.WriteLine("[DB] Table ready.");
            }
        }
    }
}
