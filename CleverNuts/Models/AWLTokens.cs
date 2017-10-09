using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Globalization;
using System.Web.Security;

namespace CleverNuts.Models
{
    public class AWLTokensContext : DbContext
    {
        public AWLTokensContext()
            : base("DefaultConnection")
        {
        }

        public DbSet<AWLTokens> TokenGamesDuo { get; set; }
    }

    [Table("AWLTokens")]
    public class AWLTokens
    {
        [Key]
        public string Token { get; set; }
    }
}
