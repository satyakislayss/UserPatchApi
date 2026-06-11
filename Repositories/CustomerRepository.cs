using Mono.Data.Sqlite;
using UserPatchApi.Database;
using UserPatchApi.Models;

namespace UserPatchApi.Repositories
{
    public class CustomerRepository
    {
        public Customer GetByCliref(string cliref)
        {
            using (var conn = new SqliteConnection(DatabaseConfig.ConnectionString))
            {
                conn.Open();
                var cmd = conn.CreateCommand();
                cmd.CommandText = "SELECT Cliref, FullName, Email, Mobile FROM Customers WHERE Cliref = @cliref;";
                cmd.Parameters.AddWithValue("@cliref", cliref);

                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) return null;
                    return new Customer
                    {
                        Cliref   = reader["Cliref"].ToString(),
                        FullName = reader["FullName"].ToString(),
                        Email    = reader["Email"].ToString(),
                        Mobile   = reader["Mobile"].ToString()
                    };
                }
            }
        }

        public bool Update(string cliref, string email, string mobile)
        {
            using (var conn = new SqliteConnection(DatabaseConfig.ConnectionString))
            {
                conn.Open();
                var cmd = conn.CreateCommand();
                cmd.CommandText = @"
                    UPDATE Customers
                    SET Email  = COALESCE(@email,  Email),
                        Mobile = COALESCE(@mobile, Mobile)
                    WHERE Cliref = @cliref;";
                cmd.Parameters.AddWithValue("@email",  (object)email  ?? System.DBNull.Value);
                cmd.Parameters.AddWithValue("@mobile", (object)mobile ?? System.DBNull.Value);
                cmd.Parameters.AddWithValue("@cliref", cliref);

                return cmd.ExecuteNonQuery() > 0;
            }
        }
    }
}
