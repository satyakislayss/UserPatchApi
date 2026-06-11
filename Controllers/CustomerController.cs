using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using UserPatchApi.Models;
using UserPatchApi.Repositories;

namespace UserPatchApi.Controllers
{
    [RoutePrefix("api/customers")]
    public class CustomerController : ApiController
    {
        private readonly CustomerRepository _repo = new CustomerRepository();

        // PATCH api/customers/{cliref}
        [HttpPatch]
        [Route("{cliref}")]
        public IHttpActionResult PatchCustomer(string cliref, [FromBody] PatchRequest request)
        {
            // 400 — no body or both fields null
            if (request == null || (request.Email == null && request.Mobile == null))
                return BadRequest("Provide at least one field to update: email or mobile.");

            // 400 — basic email format check
            if (request.Email != null && !request.Email.Contains("@"))
                return BadRequest("Invalid email format.");

            // 400 — basic mobile check (10 digits)
            if (request.Mobile != null && request.Mobile.Length != 10)
                return BadRequest("Mobile must be 10 digits.");

            Customer existing;
            try
            {
                existing = _repo.GetByCliref(cliref);
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);  // 500
            }

            // 404 — cliref not found
            if (existing == null)
                return NotFound();

            try
            {
                _repo.Update(cliref, request.Email, request.Mobile);
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);  // 500
            }

            // 200 — return updated customer
            var updated = _repo.GetByCliref(cliref);
            return Ok(new {
                message  = "Customer updated successfully.",
                customer = updated
            });
        }
    }
}
