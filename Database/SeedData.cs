using System;
using Mono.Data.Sqlite;

namespace UserPatchApi.Database
{
    public static class SeedData
    {
        public static void Seed()
        {
            using (var conn = new SqliteConnection(DatabaseConfig.ConnectionString))
            {
                conn.Open();

                // Only seed if table is empty
                var countCmd = conn.CreateCommand();
                countCmd.CommandText = "SELECT COUNT(*) FROM Customers;";
                var count = (long)countCmd.ExecuteScalar();
                if (count > 0)
                {
                    Console.WriteLine("[Seed] Data already exists, skipping.");
                    return;
                }

                var customers = new[]
                {
                    ("CLR001", "Sayak Roy",      "sayak@example.com",   "9876543210"),
                    ("CLR002", "Priya Sharma",   "priya@example.com",   "9123456780"),
                    ("CLR003", "Arjun Mehta",    "arjun@example.com",   "9001234567"),
                    ("CLR004", "Neha Bose",      "neha@example.com",    "9812345678"),
                    ("CLR005", "Rahul Gupta",    "rahul@example.com",   "9700123456"),
                };

                foreach (var (cliref, name, email, mobile) in customers)
                {
                    var cmd = conn.CreateCommand();
                    cmd.CommandText = @"
                        INSERT INTO Customers (Cliref, FullName, Email, Mobile)
                        VALUES (@cliref, @name, @email, @mobile);";
                    cmd.Parameters.AddWithValue("@cliref",  cliref);
                    cmd.Parameters.AddWithValue("@name",    name);
                    cmd.Parameters.AddWithValue("@email",   email);
                    cmd.Parameters.AddWithValue("@mobile",  mobile);
                    cmd.ExecuteNonQuery();
                }

                Console.WriteLine("[Seed] 5 customers inserted.");
            }
        }
    }
}
