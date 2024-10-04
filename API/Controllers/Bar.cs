using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [Produces("application/json")]
    [Route("api/bar")]
    //[Authorize(Roles = "customer")]
    public class BarController : Controller
{
    [HttpPost]
    public async Task<IActionResult> Post([FromBody] Drink drink)
    {
        if (drink == null || string.IsNullOrEmpty(drink.DrinkName))
        {
            return BadRequest("Invalid data.");
        }

        // Simulating an asynchronous operation (e.g., saving to a database)
        await Task.Delay(100);  // Replace with a real async operation

        return Ok($"Success! Received order for: {drink.DrinkName}");
    }
}
}