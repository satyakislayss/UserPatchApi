using System;
using System.Configuration;
using Microsoft.Owin.Hosting;
using UserPatchApi.Database;

namespace UserPatchApi
{
    class Program
    {
        static void Main(string[] args)
        {
            // Init DB and seed
            DatabaseConfig.Initialize();
            SeedData.Seed();

            string baseUrl = ConfigurationManager.AppSettings["BaseUrl"] ?? "http://localhost:5000/";

            using (WebApp.Start<Startup>(baseUrl))
            {
                Console.WriteLine($"[API] Running at {baseUrl}");
                Console.WriteLine("[API] PATCH http://localhost:5000/api/customers/{{cliref}}");
                Console.WriteLine("[API] Press Enter to stop...");
                Console.ReadLine();
            }
        }
    }
}
