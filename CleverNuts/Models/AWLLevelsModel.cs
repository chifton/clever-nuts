using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Globalization;
using System.Web.Security;

namespace CleverNuts.Models
{
    public class AWLLevelsContext : DbContext
    {
        public AWLLevelsContext()
            : base("DefaultConnection")
        {
        }

        public DbSet<AWLLevels> LevelsTable { get; set; }
    }

    [Table("AWLLevels")]
    public class AWLLevels
    {
        [Key]
        [DatabaseGeneratedAttribute(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public int levelniveau { get; set; }
        public int topalealevel { get; set; }
        public int agitation { get; set; }
    }
}
