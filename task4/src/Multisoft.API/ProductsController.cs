using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll() 
    {
        return Ok(new[] 
        {
            new { Id = 1, Name = "Product A" },
            new { Id = 2, Name = "Product B" }
        });
    }
}