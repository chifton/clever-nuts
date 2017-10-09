using CleverNuts.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Transactions;
using System.Web.Security;
using System.Diagnostics;
using DotNetOpenAuth.AspNet;
using Microsoft.Web.WebPages.OAuth;
using WebMatrix.WebData;
using CleverNuts.Filters;
using CleverNuts.Services;

namespace CleverNuts.Controllers
{
    public class ManagementController : ApplicationRealController
    {
        //
        // GET: /Management/
        // Pour gérer les utilisateurs et les anonymes du jeu
        // Attribue des Ids générés automatiquement pour jouer
        // Supprime les ids de joueurs déconnectés, puis les réutilise pour d'autres joueurs
        // Gère la liste des connectés
        // Permet de choisir ses adversaires
        // ...
        public ActionResult Index()
        {
            return View();
        }
    }
}